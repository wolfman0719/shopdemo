Class Shop.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Shop.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Place Order" Category="" ClassName="Shop.Operation.PlaceOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Shop.Service.FileService" Category="" ClassName="Shop.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath">/intersystems/iris/shop/message/arc</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Adapter" Name="FilePath">/intersystems/iris/shop/message/in</Setting>
    <Setting Target="Adapter" Name="WorkPath">/intersystems/iris/shop/message/work</Setting>
  </Item>
</Production>
}

}
