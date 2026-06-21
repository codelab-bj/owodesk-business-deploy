#!/usr/bin/env bash
# OwoDesk Business — installation serveur dédié client

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "Copiez env.business.example vers .env et configurez les variables."
  exit 1
fi

if [[ ! -f .license ]]; then
  echo "Fichier .license manquant (JSON reçu par e-mail après paiement Business dédié)."
  exit 1
fi

# shellcheck disable=SC1091
source .env

if [[ -z "${INSTANCE_ID:-}" ]]; then
  echo "INSTANCE_ID requis dans .env"
  exit 1
fi

if [[ -z "${DEDICATED_HEARTBEAT_SECRET:-}" ]]; then
  echo "DEDICATED_HEARTBEAT_SECRET requis dans .env"
  exit 1
fi

if [[ -n "${GHCR_PULL_TOKEN:-}" ]]; then
  echo "$GHCR_PULL_TOKEN" | docker login ghcr.io -u "${GHCR_PULL_USERNAME:-owoclient}" --password-stdin
fi

echo "[owodesk] Pull des images (${GHCR_BUSINESS_IMAGE:-?})..."
docker compose -f docker-compose.business.yml pull

echo "[owodesk] Démarrage stack..."
docker compose -f docker-compose.business.yml up -d

echo "[owodesk] Migrations..."
docker compose -f docker-compose.business.yml exec -T backend python manage.py makemigrations --noinput || true
docker compose -f docker-compose.business.yml exec -T backend python manage.py migrate --noinput

echo "[owodesk] Installation licence..."
docker compose -f docker-compose.business.yml exec -T backend python manage.py install_license /app/.license

echo ""
echo "Installation terminée."
echo "  Frontend : ${FRONTEND_URL:-http://localhost:${FRONTEND_PORT:-8080}}"
echo "  API directe (debug) : port ${BACKEND_PORT:-8000}"
echo "  Heartbeat automatique via Celery Beat (~30 min)"
