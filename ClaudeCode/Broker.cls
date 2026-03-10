Class Shop.Broker Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

Parameter HandleCorsRequest = 1;

Parameter UseSession As Integer = 1;

XData UrlMap
{
<Routes>
  <Route Url="/product/:code" Method="GET" Call="Shop.Rest.Product:getRecord"/>
  <Route Url="/products" Method="GET" Call="Shop.Rest.Product:listRecords"/>
  <Route Url="/deleteproduct/:code" Method="GET" Call="Shop.Rest.Product:deleteRecord"/>
  <Route Url="/addproduct" Method="POST" Call="Shop.Product:createRecord"/>
  <Route Url="/modifyproduct" Method="POST" Call="Shop.Rest.Product:modifyRecord"/>
  <Route Url="/customer/:id" Method="GET" Call="Shop.Rest.Customer:getRecord"/>
  <Route Url="/customers" Method="GET" Call="Shop.Rest.Customer:listRecords"/>
  <Route Url="/deletecustomer/:id" Method="GET" Call="Shop.Rest.Customer:deleteRecord"/>
  <Route Url="/addcustomer" Method="POST" Call="Shop.Customer:createRecord"/>
  <Route Url="/modifycustomer" Method="POST" Call="Shop.Rest.Customer:modifyRecord"/>
  <Route Url="/addorder" Method="POST" Call="Shop.Rest.POrder:createRecord"/>
  <Route Url="/order/:id" Method="GET" Call="Shop.Rest.POrder:getRecord"/>
  <Route Url="/orders" Method="GET" Call="Shop.Rest.POrder:listRecords"/>
  <Route Url="/checkpassword/:userid/:password" Method="GET" Call="Shop.Rest.Customer:checkPassword"/>
  <Route Url="/addEntry" Method="POST" Call="AddEntry"/>
</Routes>
}

/// かごへのエントリ追加・削除を行い、注文リストをJSON形式で返す
ClassMethod AddEntry() As %Status
{
  set status = $$$OK

  try {

    if $data(%request) {
      set %response.ContentType = "application/json"
      set %response.CharSet = "utf-8"
    }

    set return = {}

    // リクエストボディ(JSON)の読み取り
    set body = ##class(%DynamicObject).%FromJSON(%request.Content)
    set id     = body.id
    set amount = body.amount

    // 顧客情報の呼び出し
    if $get(%session.Data("oid")) = "" {
      set cust = ""
    }
    else {
      set cust = ##class(Shop.Customer).%OpenId(%session.Data("oid"))
    }
    if cust = "" {
      set return.LogoutMessage = "ログアウトされました。\n再度ログインしてください。"
      write return.%ToJSON()
      quit
    }

    // かごにエントリを追加・削除
    if +amount = 0 {
      // 個数が0の場合、かごにエントリがなければエラーを返す
      if '$data(%session.Data("basket", id)) {
        set return.ErrorMessage = "個数を入力してください"
        write return.%ToJSON()
        quit
      }
      // かごからエントリを削除
      kill %session.Data("basket", id)
    }
    else {
      // かごにエントリを追加
      set %session.Data("basket", id) = amount
    }

    // 注文件数の取得
    set id = "", count = 0
    for {
      set id = $order(%session.Data("basket", id))
      quit:id=""
      set id($increment(count)) = id
    }

    // 注文件数をセット
    set return.OrderLength = count

    // 注文IDと表示行の配列をセット
    set orderIds  = []
    set orderLines = []
    set total = 0
    for i = 1:1:count {
      set oref = ##class(Shop.Product).%OpenId(id(i))
      set item = $extract(oref.Name, 1, $zposition(oref.Name, 20))
      set line = item _ $justify("", 20 - $zwidth(item)) _ " " _ $justify(%session.Data("basket", id(i)), 3)
      // ObjectScriptの配列は1基点 → Javascriptの0基点に合わせて末尾追加
      do orderIds.%Push(id(i))
      do orderLines.%Push(line)
      set total = total + (cust.determinePrice(oref.ListPrice) * %session.Data("basket", id(i)))
    }
    set return.OrderIds   = orderIds
    set return.OrderLines = orderLines
    set return.Total      = $fnumber(total, ",")

    write return.%ToJSON()

  }
  catch e {
    set status = e.AsStatus()
  }

  quit status
}

/// REST API定義の登録
ClassMethod CreateAPIDefinition() As %Status
{
    Set sc = $$$OK
    set namespace = $namespace
    set $namespace = "%SYS"
    set sec = ##class("Security.Applications").%New()
    set sec.Name        = "/csp/"_namespace_"/api"
    set sec.NameSpace   = namespace
    set sec.DispatchClass = "Shop.API"
    set sec.AutheEnabled = 96
    set sec.CookiePath = "/csp/"_namespace_"/"
    set sc = sec.%Save()
    set $namespace = namespace

    Return sc
}

}
