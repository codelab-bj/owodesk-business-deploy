# OwoDesk Business — kit déploiement serveur dédié

Dépôt **client / ops** : scripts d’installation Docker pour une instance OwoDesk Business **single-tenant** chez le client.

> Les images applicatives sont publiées par Code Lab sur GHCR (`owodesk-business`, `owodesk-frontend`).  
> Ce dépôt ne contient **pas** le code source Django/React.

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
git clone https://github.com/codelabbj/owodesk-business-deploy.git /opt/owodesk
cd /opt/owodesk
cp env.business.example .env
nano .env          # INSTANCE_ID, secrets, mots de passe
nano .license      # JSON reçu par e-mail après paiement Business
chmod +x install.sh owodesk-update.sh
./install.sh
```

Accès : `http://VOTRE_SERVEUR:8080` (frontend, nginx proxifie `/api` vers le backend).

## Versions

Aligner `OWODESK_IMAGE_TAG` dans `.env` avec la version livrée par Code Lab (ex. `1.0.0`).

```bash
./owodesk-update.sh 1.0.0
```

## Support

contact@codelab.bj — visio d’accompagnement incluse au forfait Business dédié.
