# Installation client — OwoDesk Business dédié

## Prérequis

- Serveur Linux (VPS, VM, on-premise) — **pas** le serveur `api.erp.codelab.bj`
- Docker Engine 24+ et Docker Compose v2
- Kit reçu par e-mail après paiement : `.license`, `INSTANCE_ID`, secret heartbeat, token GHCR
- Accès sortant HTTPS vers `ghcr.io` et `api.erp.codelab.bj`
- **Aucun compte GitHub** requis en HTTPS ; en **SSH**, une clé SSH doit être configurée sur le serveur (`ssh -T git@github.com`)

## 1. Récupérer le kit (clone public)

```bash
sudo mkdir -p /opt/owodesk
sudo chown "$USER:$USER" /opt/owodesk
git clone git@github.com:codelab-bj/owodesk-business-deploy.git /opt/owodesk
cd /opt/owodesk
chmod +x install.sh owodesk-update.sh
```

## 2. Fichier `.license`

Créer `/opt/owodesk/.license` avec le JSON complet de l’e-mail (clés `payload` + `sig`).

## 3. Fichier `.env`

```bash
cp env.business.example .env
nano .env
```

| Variable | Source |
|----------|--------|
| `INSTANCE_ID` | E-mail kit |
| `DEDICATED_HEARTBEAT_SECRET` | E-mail kit |
| `GHCR_PULL_USERNAME` | E-mail kit (`owoclient`) |
| `GHCR_PULL_TOKEN` | E-mail kit (PAT GitHub) |
| `DB_PASSWORD`, `SECRET_KEY` | À générer (valeurs uniques) |
| `FRONTEND_URL`, `PUBLIC_API_URL` | URL du serveur client (`http://IP:8080` ou domaine) |
| `OWODESK_IMAGE_TAG` | Version livrée (ex. `latest`) |
| `GHCR_BUSINESS_IMAGE` / `GHCR_FRONTEND_IMAGE` | Même tag que `OWODESK_IMAGE_TAG` |

Générer `SECRET_KEY` :

```bash
python3 -c "import secrets; print(secrets.token_urlsafe(48))"
```

## 4. Installer

```bash
./install.sh
```

## 5. Vérifier

```bash
docker compose -f docker-compose.business.yml ps
curl -s http://localhost:8000/api/licensing/local/license-status/
```

Ouvrir le navigateur : `http://VOTRE_IP:8080`

Dans le super-admin Code Lab, l’instance passe à **active** après le premier heartbeat (~30 min max).

## 6. Mettre à jour

```bash
git pull
./owodesk-update.sh latest
```

## Dépannage

| Problème | Action |
|----------|--------|
| `unauthorized` au pull | Token GHCR expiré → demander renvoi kit |
| `403 LICENSE_INVALID` | Vérifier `.license` complet |
| Frontend sans API | `PUBLIC_API_URL` = URL frontend (`:8080`), pas `:8000` |
| `not found` sur image | Vérifier le tag dans `.env` (`latest` si `1.0.0` absent) |

Support : contact@codelab.bj
