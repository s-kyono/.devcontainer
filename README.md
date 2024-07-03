# .devcontanier

## VScodeにてコンテナ内で開発環境を構築できるBase環境

## カスタマイズ

- 事前にnetwork・volumesを作成する
  ``` bin/bash
  docker network create devcontainer_contanier
  docker volumes create devcontainer_contanier
  ```

- `docker-compose.yml`に記載している`.devcontainer`を好きな値にする
  ``` yaml
    services:
      devcontainer:
        container_name: devcontainer_contanier
        build: 
          context: .
          args:
            - GITHUB_EMAIL=${GITHUB_EMAIL}
            - GITHUB_ACCOUNT=${GITHUB_ACCOUNT}
            - GITHUB_ACCESS_TOKEN=${GITHUB_ACCESS_TOKEN}
        tty: true
        volumes:
          - devcontainer_contanier:/srv
          - ../.devcontainer/:/srv/.devcontainer
          - /var/run/docker.sock:/var/run/docker.sock
        networks:
          - devcontainer_contanier_nw

    volumes:
      devcontainer_contanier:
        external: true

    networks:
      devcontainer_contanier_nw:
        external: true
  ```

## 使い方

- リポジトリをcloneする
- clone後、dockerのnetwork・volumesを作成
- VSCodeを開く
- コンテナーで再度開くポップアップが表示されるので開くを押下する
- コンテナ内で開発可能
- コンテナ内でdockerコマンドが使える