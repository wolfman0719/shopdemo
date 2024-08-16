# reactアプリケーション設定

## react app テンプレート作成

```% npx create-react-app shopdemo --template typescript```

## bootstrapインストール

```% cd shopdemo```

```% npm install react-bootstrap bootstrap```

## react-router-domインストール

```% npm install react-router-dom```

## axios インストール

```% npm install axios```

## ファイルコピー

以下のファイルをここからダウンロード（またはgit clone）し、上で作成したテンプレートディレクトリにコピーする

- public

  index.html

- 直下

  index.tsx

  App.tsx

  serverconfig.json

 - components

   Header.tsx
   
   Login.tsx

   OrderEntry.tsx
   
   productList.tsx

   Shop.tsx

   ShoppingCart.tsx

- hooks
  
  useWindowSize.tsx
   
## serverconfig.jsonの調整

### MacOS（BrewでインストールしたApache）の場合

 - IRISサーバーのIPアドレス、ポート番号を反映
 - (IPアドレス = localhost IPポート番号: 8080)
 - Webアプリケーション名
 - （デフォルト　/api/shop）

### Windows（IIS）の場合

 - IRISサーバーのIPアドレス、ポート番号を反映
 - (IPアドレス = localhost IPポート番号: 80)
 - Webアプリケーション名
 - （デフォルト　/iris/api/shop）

### Private Web Serverの場合

 - IRISサーバーのIPアドレス、ポート番号を反映
 - (IPアドレス = localhost IPポート番号: 52773)
 - Webアプリケーション名
 - （デフォルト　/api/shop）

## reactアプリケーションの起動

- npm start

    Starts the development server.

- npm run build

    Bundles the app into static files for production.

- npm test

    Starts the test runner.

- npm run eject

    Removes this tool and copies build dependencies, configuration files
    and scripts into the app directory. If you do this, you can’t go back!

## CORS設定

開発モード(npm start)で動作させるためには、CORSの設定が必要

### http.confの修正（以下の行を追加）

macOSの場合

```
/opt/homebrew/etc/httpd
```

```
<IfModule mod_headers>
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET,POST,PUT,DELETE,OPTIONS, PATCH"
    Header set Access-Control-Allow-Headers "Content-Type,Authorization,X-Requested-With"
    Header set Access-Control-Allow-Credentials "true"
</IfModule>
```

### IIS

IISの場合は、以下の設定を参考

https://mihono-bourbon.com/iis-cors/
