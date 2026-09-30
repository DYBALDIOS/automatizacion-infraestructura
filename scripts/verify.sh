#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../terraform"

PROJECT="iac"
NETWORK="red-iac"
WEB_IP="10.10.0.10"; APP_IP="10.10.0.20"; DB_IP="10.10.0.30"
FAIL=0

check() {  # check "descripción" comando...
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then echo "[OK]   $desc"; else echo "[FAIL] $desc"; FAIL=1; fi
}

echo "=== 1. Terraform ==="
terraform validate
terraform state list

echo; echo "=== 2. Contenedores ==="
docker ps --filter "name=${PROJECT}-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo; echo "=== 3. Red ==="
docker network ls --filter "name=${NETWORK}"
docker network inspect "$NETWORK" \
  --format '{{range .IPAM.Config}}Subred: {{.Subnet}}{{end}}'
docker network inspect "$NETWORK" \
  --format '{{range .Containers}}{{.Name}} -> {{.IPv4Address}}{{"\n"}}{{end}}'

echo; echo "=== 4. Pruebas ==="
check "contenedor web en ejecución" docker exec ${PROJECT}-web true
check "contenedor app en ejecución" docker exec ${PROJECT}-app true
check "contenedor db en ejecución"  docker exec ${PROJECT}-db true
check "web responde HTTP en localhost" curl -sf http://localhost
# Conectividad interna entre servidores (funciona en Linux, Mac y Windows)
check "app -> web (HTTP $WEB_IP:80)" docker exec ${PROJECT}-app python -c \
  "import urllib.request; urllib.request.urlopen('http://$WEB_IP', timeout=3)"
check "app -> db (TCP $DB_IP:5432)" docker exec ${PROJECT}-app python -c \
  "import socket; socket.create_connection(('$DB_IP',5432), timeout=3)"
check "web -> app (TCP $APP_IP:8000)" docker exec ${PROJECT}-web \
  sh -c "nc -z -w3 $APP_IP 8000"
check "db acepta conexiones (pg_isready)" docker exec ${PROJECT}-db pg_isready -U appuser

# ping desde el host: solo funciona en Linux
if [ "$(uname -s)" = "Linux" ]; then
  for ip in $WEB_IP $APP_IP $DB_IP; do
    check "ping desde host a $ip" ping -c 2 -W 2 "$ip"
  done
fi

echo
if [ $FAIL -eq 0 ]; then echo "RESULTADO: verificación exitosa"; else echo "RESULTADO: hubo fallos"; fi
exit $FAIL
