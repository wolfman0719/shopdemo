Class Shop.Broker Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

Parameter HandleCorsRequest = 1;

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
</Routes>
}

}
