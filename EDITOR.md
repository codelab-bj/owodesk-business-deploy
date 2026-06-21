# Publication GHCR — Code Lab (éditeur)

Les **images Docker** se buildent depuis les dépôts applicatifs.  
Ce dépôt (`owodesk-business-deploy`) ne contient que le kit client.

> **Identités GitHub** : `codelabbj` = compte utilisateur (backend → `ghcr.io/codelabbj/owodesk-business`).  
> `codelab-bj` = organisation (frontend → `ghcr.io/codelab-bj/owodesk-frontend`, kit deploy).

## Architecture

```
codelabbj/erp_crm_backend   → Dockerfile + CI → ghcr.io/codelabbj/owodesk-business
codelab-bj/erp_crm_frontend → Dockerfile + CI → ghcr.io/codelab-bj/owodesk-frontend
codelab-bj/owodesk-business-deploy → compose + install.sh (tags d’images pinés)
```

## 1. Première publication (GitHub Actions)

### Backend

Dépôt `erp_crm_backend` → onglet **Actions** → workflow **Publish GHCR Business** → **Run workflow** → tag `1.0.0`

Ou pousser un tag git :

```bash
git tag business-v1.0.0
git push origin business-v1.0.0
```

### Frontend

Dépôt `erp_crm_frontend` → workflow **Publish GHCR Frontend** → tag `1.0.0`

Ou :

```bash
git tag business-v1.0.0
git push origin business-v1.0.0
```

## 2. Build local (secours)

```bash
# Backend
cd erp_crm_backend
docker build -t ghcr.io/codelabbj/owodesk-business:1.0.0 .
docker push ghcr.io/codelabbj/owodesk-business:1.0.0

# Frontend
cd erp_crm_frontend
docker build --build-arg VITE_API_BASE_URL= -t ghcr.io/codelab-bj/owodesk-frontend:1.0.0 .
docker push ghcr.io/codelab-bj/owodesk-frontend:1.0.0
```

Login : `echo $GHCR_TOKEN | docker login ghcr.io -u VOTRE_COMPTE --password-stdin`

## 3. Configurer GHCR (une fois)

1. Packages `owodesk-business` et `owodesk-frontend` → **Private**
2. Accès lecture pour le compte **`owodesk-client`** (tokens clients générés par l’ERP)
3. Vérifier : `docker pull ghcr.io/codelabbj/owodesk-business:1.0.0`

## 4. Livrer au client

1. Mettre à jour `env.business.example` dans **ce dépôt** : `OWODESK_IMAGE_TAG=1.0.0` et lignes `GHCR_*`
2. Tag git deploy : `v1.0.0`
3. Client clone / met à jour ce dépôt et lance `./install.sh`

## 5. Ordre opérationnel

| # | Action |
|---|--------|
| 1 | CI backend + frontend → GHCR |
| 2 | Tag + release `owodesk-business-deploy` |
| 3 | Paiement client → e-mail kit (licence + token pull) |
| 4 | Client : clone deploy + `./install.sh` |
