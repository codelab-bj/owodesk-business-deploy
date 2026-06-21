# Publication GHCR — Code Lab (éditeur)

Les **images Docker** se buildent depuis les dépôts applicatifs.  
Ce dépôt (`owodesk-business-deploy`) ne contient que le kit client.

> Tous les dépôts et packages GHCR sont sous l’organisation **`codelab-bj`**.

## Architecture

```
codelab-bj/erp_crm_backend          → ghcr.io/codelab-bj/owodesk-business
codelab-bj/erp_crm_frontend         → ghcr.io/codelab-bj/owodesk-frontend
codelab-bj/owodesk-business-deploy  → compose + install.sh (tags pinés)
```

## 1. Publication (GitHub Actions)

### Backend

Dépôt `codelab-bj/erp_crm_backend` → **Actions** → **Publish GHCR Business** → tag `1.0.0`

Ou tag git :

```bash
git tag business-v1.0.0
git push origin business-v1.0.0
```

### Frontend

Dépôt `codelab-bj/erp_crm_frontend` → **Publish GHCR Frontend** → tag `1.0.0`

## 2. Vérifier les packages

- https://github.com/orgs/codelab-bj/packages
- Images attendues :
  - `ghcr.io/codelab-bj/owodesk-business:1.0.0`
  - `ghcr.io/codelab-bj/owodesk-frontend:1.0.0`

## 3. Compte service GHCR (`owoclient`)

Compte GitHub dédié (une fois) : https://github.com/owoclient

1. Connecté en **owoclient** → générer un PAT classic scope **`read:packages`**
2. Sur **api.erp.codelab.bj** (`.env` prod backend) :
   ```env
   GHCR_CLIENT_USERNAME=owoclient
   GHCR_CLIENT_PULL_TOKEN=ghp_...
   ```
3. L’e-mail kit d’installation inclura automatiquement ce login + token.

## 4. Accès client (pull packages)

Pour chaque package → **Package settings** :

1. **Visibility** : Private
2. **Manage Actions access** : repos `erp_crm_backend` / `erp_crm_frontend` en Write (CI)
3. **Manage access** : ajouter le compte **`owoclient`** en **Read**

Test :

```bash
docker login ghcr.io -u owoclient -p <TOKEN>
docker pull ghcr.io/codelab-bj/owodesk-business:1.0.0
docker pull ghcr.io/codelab-bj/owodesk-frontend:1.0.0
```

## 5. Build manuel (secours)

```bash
# Backend
cd erp_crm_backend
docker build -t ghcr.io/codelab-bj/owodesk-business:1.0.0 .
docker push ghcr.io/codelab-bj/owodesk-business:1.0.0

# Frontend
cd erp_crm_frontend
docker build --build-arg VITE_API_BASE_URL= -t ghcr.io/codelab-bj/owodesk-frontend:1.0.0 .
docker push ghcr.io/codelab-bj/owodesk-frontend:1.0.0
```

## 6. Mettre à jour le tag client

Dans ce dépôt, éditer `env.business.example` (`OWODESK_IMAGE_TAG`, lignes `GHCR_*_IMAGE`).

Puis commit + push ; le client met à jour avec `./owodesk-update.sh <tag>`.
