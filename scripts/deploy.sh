#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../terraform"

echo "==> terraform init";     terraform init
echo "==> terraform fmt";      terraform fmt
echo "==> terraform validate"; terraform validate
echo "==> terraform plan";     terraform plan -out=tfplan
echo "==> terraform apply";    terraform apply -auto-approve tfplan

echo "==> Despliegue terminado"
terraform output
