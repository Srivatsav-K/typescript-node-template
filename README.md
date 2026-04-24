# TypeScript Node template

A small, opinionated starter for **Node.js** services written in **TypeScript**: strict compiler settings, **ESLint** (with security rules), **pnpm** with workspace policies, and a **multi-stage Docker** build for lean production images.

## Features

- **TypeScript 6** with `NodeNext` modules, `ES2024` target, and strict options (`strict`, `noUncheckedIndexedAccess`, and more)
- **ESLint 10** flat config: `@eslint/js`, `typescript-eslint` recommended, and `eslint-plugin-security` recommended, plus a few style rules
- **Development loop**: `nodemon` watches `src` and runs entrypoint via `ts-node` (no build step while hacking)
- **Build**: `lint` then `tsc` to `dist/`, with source maps and incremental builds
- **pnpm** `packageManager` pin and engine constraints; `pnpm-workspace.yaml` sets supply-chain oriented defaults (`minimumReleaseAge`, `trustPolicy`, `blockExoticSubdeps`)
- **Docker**: Alpine-based image, separate `deps` / `build` / `final` stages, `pnpm install --frozen-lockfile`, non-root `node` user, `NODE_ENV=production` in the runtime stage

## Requirements

- **Node.js** `>= 24.0.0` (see [`.nvmrc`](.nvmrc) for a tested patch version)
- **pnpm** `>= 10.33.2` (enforced via [`packageManager`](package.json))

## Quick start

```bash
git clone https://github.com/Srivatsav-K/typescript-node-template.git
cd typescript-node-template
pnpm install
pnpm dev
```

In another terminal, build and run the compiled output:

```bash
pnpm build
pnpm start
```

## Scripts

| Command            | What it does                                                                        |
| ------------------ | ----------------------------------------------------------------------------------- |
| `pnpm dev`         | Watch `src/` and re-run the app with `ts-node` (see [`nodemon.json`](nodemon.json)) |
| `pnpm build`       | Run ESLint on `src/**/*.ts`, then `tsc`                                             |
| `pnpm clean`       | Remove `dist/`                                                                      |
| `pnpm clean-build` | `clean` then `build`                                                                |
| `pnpm start`       | `node dist/index.js` (run after `build`)                                            |
| `pnpm lint`        | ESLint on TypeScript sources                                                        |

## Project layout

```text
.
├── src/              # Application source (TypeScript)
├── dist/             # tsc output (gitignored)
├── eslint.config.mjs
├── tsconfig.json
├── nodemon.json
├── Dockerfile
├── pnpm-workspace.yaml
└── package.json
```

## Docker

Build and run a production image (adjust tags and port mapping as you like):

```bash
docker build -t typescript-node-template .
docker run --rm -p 3000:3000 typescript-node-template
```

The image runs `pnpm run start` and exposes **3000**; wire your HTTP server to that port when you add one.

## License

**ISC** — Srivatsav K.

---

Use this repo as a **GitHub template** or clone it and replace `typescript-node-template` with your app name, then extend `src/` and dependencies from there.
