#!/usr/bin/env bash
# Mise à jour OwoDesk Business — ./owodesk-update.sh [tag]
# Exemple : ./owodesk-update.sh 1.0.1

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

TAG="${1:-}"

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env
fi

TAG="${TAG:-${OWODESK_IMAGE_TAG:-latest}}"
BUSINESS_ORG="${GHCR_BUSINESS_ORG:-${GHCR_ORG:-codelabbj}}"
FRONTEND_ORG="${GHCR_FRONTEND_ORG:-${GHCR_ORG:-codelab-bj}}"

export GHCR_BUSINESS_IMAGE="${GHCR_BUSINESS_IMAGE:-ghcr.io/${BUSINESS_ORG}/owodesk-business:${TAG}}"
export GHCR_FRONTEND_IMAGE="${GHCR_FRONTEND_IMAGE:-ghcr.io/${FRONTEND_ORG}/owodesk-frontend:${TAG}}"

if [[ -n "${GHCR_PULL_TOKEN:-}" ]]; then
  echo "$GHCR_PULL_TOKEN" | docker login ghcr.io -u owodesk-client --password-stdin
fi

echo "[owodesk-update] Mise à jour vers ${TAG}..."
docker compose -f docker-compose.business.yml pull
docker compose -f docker-compose.business.yml up -d
docker compose -f docker-compose.business.yml exec -T backend python manage.py migrate --noinput

echo "[owodesk-update] Terminé — pensez à mettre OWODESK_IMAGE_TAG=${TAG} dans .env"
