# Shop DEMO

ShopデモアプリケーションのDocker Build


## ビルドプロセス

### Build & Run
* ```docker-compose up -d --build```


## 起動方法

### デモアプリケーション

[localhost:52778/csp/user/Order/Shop/login.htm](http://localhost:52778/csp/user/Order/Shop/login.htm)

### 管理ポータル

[localhost:52778/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS](http://localhost:52778/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS)

### Webターミナル

[localhost:52778/terminal/?IRISUsername=_system&IRISPassword=SYS](http://localhost:52778/terminal/?IRISUsername=_system&IRISPassword=SYS)

### RESTインターフェース

#### GETサンプル

http://localhost:52778/shop/products?IRISUsername=_system&IRISPassword=SYS

content-type application/json; charset=utf-8

#### POSTサンプル

http://localhost:52778/shop/addorder?IRISUserName=_system&IRISPassword=SYS

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

```docker ps
docker exec -ti shopdemo /bin/sh

iris session iris

>do ##class(Ens.Director).StartProduction("Shop.Production")
>h

cp /intersystems/iris/shop/samples/* /intersystems/iris/shop/message/in
```

#### 結果確認

* `select * from shop.porder`
* `select * from shop.orderitem`

### NLPデモ

#### ドメイン設定

管理ポータル>Analytics>Text Analytics>ドメインアーキテクト

##### 新規作成

ドメイン設定

|項目名    |値                |
|---------|------------------|
|ドメイン名 |news             |
|クラス名   |news.nhk         |
|言語　     |Japaneseのみ選択  |

 データ位置

|項目名      |値                 |
------------|-------------------
|名前：	     |RSS_1              |
|バッチモード　|yes               |
|サーバー名	   |www3.nhk.or.jp    |
|url		  |/rss/news/cat0.xml|

#### 保存、コンパイル、構築
