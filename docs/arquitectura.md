# Arquitectura

```
            Red privada Docker "red-iac"
                 10.10.0.0/24 (gw 10.10.0.1)
        ┌─────────────┼──────────────┐
   ┌────▼─────┐  ┌────▼─────┐  ┌─────▼────┐
   │   WEB    │  │   APP    │  │    DB    │
   │ nginx    │  │ python   │  │ postgres │
   │10.10.0.10│  │10.10.0.20│  │10.10.0.30│
   └──────────┘  └──────────┘  └──────────┘
```

| Componente | Imagen | IP | Puerto |
|---|---|---|---|
| Web | nginx:alpine | 10.10.0.10 | 80 (publicado en el host) |
| App | python:3.12-alpine | 10.10.0.20 | 8000 |
| DB | postgres:16-alpine | 10.10.0.30 | 5432 |

## Relación entre recursos
- `docker_network.main` se crea primero.
- Las imágenes (`docker_image`) se descargan.
- `docker_container.db` se conecta a la red con IP fija.
- `docker_container.app` depende de `db` (`depends_on`).
- `docker_container.web` se conecta a la red y publica el puerto 80.
