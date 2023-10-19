# Shop DEMO

ShopデモアプリケーションのDocker Build


## ビルドプロセス

### Build & Run
* ```docker-compose up -d --build```


## 起動方法

### デモアプリケーション

[localhost:52773/csp/user/Order/Shop/login.htm](http://localhost:52773/csp/user/Order/Shop/login.htm)

### 管理ポータル

[localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS)

### Webターミナル

[localhost:52773/terminal/?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/terminal/?IRISUsername=_system&IRISPassword=SYS)

### RESTインターフェース

#### GETサンプル

http://localhost:52773/api/shop/products?IRISUsername=_system&IRISPassword=SYS

content-type application/json; charset=utf-8

#### POSTサンプル

http://localhost:52773/api/shop/addorder?IRISUserName=_system&IRISPassword=SYS

{"ShipTo":{"City":"Tokyo","Street":"Ginza","PostalCode":"1600001"},"CustomerId":1,"Items":[{"ProductId":"MNT001","Amount":1},{"ProductId":"PC001","Amount":1}]}

#### クレデンシャル情報

##### デモアプリケーション

| 項目   | 値    |
|-------|-------|
利用者ID | taro |
パスワード| taro |

##### その他

| 項目           | 値        |
|---------------|------------
| システムログイン |　_system  |
|パスワード　	   |SYS|

### SQLサンプル

* `select * from shop.porder`
* `select * from shop.orderitem`

### インターオペラビリティデモ

#### プロダクション開始と注文ファイルのコピー

```
docker ps
docker exec -ti shopdemo /bin/sh

rm /intersystems/iris/shop/message/in/.gitkeep

iris session iris

>do ##class(Ens.Director).StartProduction("Shop.Production")
>h

cp /intersystems/iris/shop/samples/* /intersystems/iris/shop/message/in
```

#### 結果確認

* `select * from shop.porder`
* `select * from shop.orderitem`


### react デモ

react-setup.md参照

#### reactアプリケーション設定

##### react app テンプレート作成

```% npx create-react-app pg --template typescript```

##### bootstrapインストール

```% cd pg```

```% npm install react-bootstrap bootstrap```

##### react-router-domインストール

```% npm install react-router-dom```

##### axios インストール

```% npm install axios```

##### ファイルコピー

以下のファイルをここからダウンロード（またはgit clone）し、上で作成したテンプレートディレクトリにコピーする

- public

  index.html

- src

  index.tsx

  App.tsx

  serverconfig.json

 - components

   Pm.tsx
   
##### serverconfig.jsonの調整

###### MacOS（BrewでインストールしたApache）の場合

 - IRISサーバーのIPアドレス、ポート番号を反映
 - (IPアドレス = localhost IPポート番号: 8080)
 - Webアプリケーション名
 - （デフォルト　/api/shop）

###### Windows（IIS）の場合

 - IRISサーバーのIPアドレス、ポート番号を反映
 - (IPアドレス = localhost IPポート番号: 80)
 - Webアプリケーション名
 - （デフォルト　/iris/api/shop）

###### Private Web Serverの場合

 - IRISサーバーのIPアドレス、ポート番号を反映
 - (IPアドレス = localhost IPポート番号: 52773)
 - Webアプリケーション名
 - （デフォルト　/api/shop）

#### reactアプリケーションの起動

- npm start

    Starts the development server.

- npm run build

    Bundles the app into static files for production.

- npm test

    Starts the test runner.

- npm run eject

    Removes this tool and copies build dependencies, configuration files
    and scripts into the app directory. If you do this, you can’t go back!

## http.confの修正（以下の行を追加）

CORSの設定が必要

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

IISの場合は、デフォルト設定でOK


