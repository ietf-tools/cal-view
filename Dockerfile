# =====================
# --- Builder Stage ---
# =====================
FROM node:24 AS builder

WORKDIR /app
COPY . .

RUN npm ci
RUN npm run build

# ===================
# --- Final Image ---
# ===================
FROM node:24
LABEL maintainer="IETF Tools Team <tools-discuss@ietf.org>"

ENV NODE_ENV=production

RUN mkdir -p /app && \
    chown node:node /app
WORKDIR /app

COPY .npmrc .npmrc
COPY index.js index.js
COPY package.json package.json
COPY package-lock.json package-lock.json
COPY --from=builder /app/dist /app/dist

RUN npm ci

USER node:node
CMD ["node", "index.js"]