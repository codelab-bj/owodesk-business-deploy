# Installation client — OwoDesk Business dédié

## Prérequis

- Serveur Linux (VPS, VM, on-premise) — **pas** le serveur `api.erp.codelab.bj`
- Docker Engine 24+ et Docker Compose v2
- Kit reçu par e-mail après paiement : `.license`, `INSTANCE_ID`, secret heartbeat, token GHCR
- Accès sortant HTTPS vers `ghcr.io` et `api.erp.codelab.bj`

## 1. Récupérer ce dépôt

```bash
sudo mkdir -p /opt/owodesk
sudo chown "$USER:$USER" /opt/owodesk
git clone https://github.com/codelab-bj/owodesk-business-deploy.git /opt/owodesk
cd /opt/owodesk
chmod +x install.sh owodesk-update.sh
```

*(Ou copier le zip du kit fourni par Code Lab.)*

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
| `GHCR_PULL_TOKEN` | E-mail kit |
| `DB_PASSWORD`, `SECRET_KEY` | À générer (valeurs uniques) |
| `FRONTEND_URL`, `PUBLIC_API_URL` | URL du serveur client (`http://IP:8080` ou domaine) |
| `OWODESK_IMAGE_TAG` | Version livrée (ex. `1.0.0`) |
| `GHCR_BUSINESS_IMAGE` / `GHCR_FRONTEND_IMAGE` | Doivent inclure le même tag |

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

Dans le super-admin Code Lab, l’instance passe à **active** après le premier heartbeat (~30 min max, ou redémarrer `celery-beat`).

## 6. Mettre à jour

```bash
./owodesk-update.sh 1.0.1
```

## Dépannage

| Problème | Action |
|----------|--------|
| `unauthorized` au pull | Token GHCR expiré → demander renvoi kit |
| `403 LICENSE_INVALID` | Vérifier `.license` complet |
| Frontend sans API | `PUBLIC_API_URL` = URL frontend (`:8080`), pas `:8000` |

Support : contact@codelab.bj
