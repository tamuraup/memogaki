---
title: "Rust WebAssembly + React (Vite) で作成したサイトを GitLab Pages へデプロイ"
date: 2024-09-17
categories: [GitLab, Rust, wasm]
---

Rust のプログラムを WebAssembly にコンパイルしたものを使う Web サイトを GitLab Pages にデプロイしたので、その時のメモ。

## 構成

`wasm` ディレクトリに Rust のプロジェクト、`web` ディレクトリに vite で作成した web プロジェクトがある。  
WebAssembly にコンパイルしたファイルは `web/public/wasm` 配置している。

```
project_root
├── wasm            # Rust Project root
│   └── ...
└── web             # Web Project root
    ├── public/wasm
    ├── ...
    └── vite.config.ts
```

## gitlab-ci

gitlab-ci.yml を以下のように作成した

```yaml
image: node:16.5.0

# wasm build
wasm-build-job:
  stage: build
  image: "rust:latest"
  script:
    - cargo install wasm-pack
    - cd wasm
    - wasm-pack build --target web --out-dir ../web/public/wasm

  # ビルドしたものを後続 job に共有する
  artifacts:
    paths:
      - web/public/wasm
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

# pages へデプロイ
pages:
  stage: deploy
  cache:
    key:
      files:
        - package-lock.json
      prefix: npm
    paths:
      - node_modules/
  script:
    - cd web
    - npm install
    - npm run build
    - cp -a dist/. ../public/
  artifacts:
    paths:
      - public
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

## 参考サイト

- https://developer.mozilla.org/ja/docs/WebAssembly/Rust_to_Wasm
- https://gitlab-docs.creationline.com/ee/ci/yaml/
