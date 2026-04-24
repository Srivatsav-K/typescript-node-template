################################################################################
# Base image for all stages
FROM node:24.14.1-alpine3.23 AS base

# Set timezone to Asia/Kolkata
ENV TZ="Asia/Kolkata"

# Install required OS packages
# RUN apk add --no-cache bash git curl

# Enable pnpm via Corepack (matches package.json engines.pnpm)
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

# Install global npm binaries
# RUN npm install -g @sentry/cli@2.17.0 sequelize-cli --unsafe-perm

# Switch to non-root user
USER node

# Set working directory for all build stages.
WORKDIR /usr/src/app


################################################################################
# Install production dependencies
FROM base AS deps

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Install only production dependencies
RUN pnpm install --frozen-lockfile --prod


################################################################################
# Build stage
FROM base AS build

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Install production and dev dependencies
RUN pnpm install --frozen-lockfile

# Copy source files and build
COPY . .

RUN pnpm run build


################################################################################
# Final runtime image
FROM base AS final

# Use production node environment by default
ENV NODE_ENV=production

COPY package.json .

# Copy production deps and build artifacts from previous stages
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

# Copy additional files
# COPY ./config ./config

# Expose port
EXPOSE 3000

# Start the application
# `service` command from deployment config overrides this if present
CMD ["pnpm", "run", "start"]
