# OwoDesk Business — kit déploiement serveur dédié

Dépôt **public** : scripts d’installation Docker pour une instance OwoDesk Business **single-tenant** chez le client.

> **Pas de compte GitHub requis** — clone HTTPS. Images GHCR **privées** (token e-mail kit).

## Contenu

| Fichier | Usage |
|---------|--------|
| `env.business.example` | Modèle de configuration → copier en `.env` |
| `docker-compose.business.yml` | Stack PostgreSQL, Redis, API, Celery, frontend |
| `install.sh` | Première installation |
| `owodesk-update.sh` | Mise à jour de version |
| `INSTALL.md` | Guide client pas à pas |
| `EDITOR.md` | Publication images GHCR (Code Lab) |

## Démarrage rapide (client)

```bash
sudo mkdir -p /opt/owodesk
sudo chown "$USER:$USER" /opt/owodesk
git clone https://github.com/codelab-bj/owodesk-business-deploy.git /opt/owodesk
cd /opt/owodesk
cp env.business.example .env
nano .env          # INSTANCE_ID, secrets, mots de passe (e-mail kit)
nano .license      # JSON reçu par e-mail après paiement Business
chmod +x install.sh owodesk-update.sh
./install.sh
```

Accès : `http://VOTRE_SERVEUR:8080` (frontend, nginx proxifie `/api` vers le backend).

## Versions

Aligner `OWODESK_IMAGE_TAG` dans `.env` avec la version livrée par Code Lab (ex. `latest` ou `1.0.1`).

```bash
git pull
./owodesk-update.sh 1.0.1
```

## Support

contact@codelab.bj — visio d’accompagnement incluse au forfait Business dédié.
