<?xml version=\"1.0\" encoding=\"utf-8\"?>
<Orders>
<#list orderParts as part><#assign items = part.item_details><#assign shipping = part.shipping_details>
  <Order>
    <OrderID><![CDATA[${part.orderId!}]]></OrderID>
    <OrderNumber><![CDATA[${part.orderName!}]]></OrderNumber>
    <OrderDate>${part.placedDate!}</OrderDate>
    <OrderStatus><![CDATA[${part.partStatusId}]]></OrderStatus>
    <LastModified>${part.lastModified}</LastModified>
    <#assign shipmentMethod = ec.entity.find("moqui.basic.Enumeration").condition("enumId",part.shipmentMethodEnumId).useCache(true).one()>
    <ShippingMethod><![CDATA[${shipmentMethod.description}]]></ShippingMethod>
    <#assign paymentMethod = ec.entity.find("moqui.basic.Enumeration").condition("enumId",part.paymentMethod!).useCache(true).one()>
    <PaymentMethod><![CDATA[${paymentMethod.description!}]]></PaymentMethod>
    <CurrencyCode>${part.currencyUom}</CurrencyCode>
    <OrderTotal>${part.partTotal}</OrderTotal>
    <TaxAmount>XX</TaxAmount>
    <ShippingAmount>${part.shippingCost}</ShippingAmount>
    <CustomerNotes><![CDATA[${part.shippingInstructions}]]></CustomerNotes>
    <InternalNotes><![CDATA[${part.shippingInstructions}]]></InternalNotes>
    <Gift>${part.isGift}</Gift>
    <GiftMessage>${part.giftMessage}</GiftMessage>
    <Customer>
      <CustomerCode><![CDATA[${part.customer_details.email}]]></CustomerCode>
      <BillTo>
        <Name><![CDATA[${part.billing_details.address.toName}]]></Name>
        <Company><![CDATA[XX]]></Company>
        <Phone><![CDATA[${part.billing_details.phone.contactNumber!}]]></Phone>
        <Email><![CDATA[${part.customer_details.email}]]></Email>
      </BillTo>
      <ShipTo>
        <#assign geo = ec.entity.find("moqui.basic.Geo").condition("geoId",shipping.address.stateProvinceGeoId!).useCache(true).one()>
        <Name><![CDATA[${shipping.address.toName!}]]></Name>
        <Company><![CDATA[XX]]></Company>
        <Address1><![CDATA[${shipping.address.address1!}]]></Address1>
        <Address2>${shipping.address.address2!}</Address2>
        <City><![CDATA[${shipping.address.city!}]]></City>
        <State><![CDATA[${geo.geoCodeAlpha2!}]]></State>
        <PostalCode><![CDATA[${shipping.address.postalCode!}]]></PostalCode>
        <Country><![CDATA[${shipping.address.countryGeoId!}]]></Country>
        <Phone><![CDATA[${shipping.phone.contactNumber!}]]></Phone>
      </ShipTo>
    </Customer>
    <Items>
    <#list items as item>
      <Item>
        <SKU><![CDATA[${item.sku}]]></SKU>
        <Name><![CDATA[${item.product_name}]]></Name>
        <ImageUrl><![CDATA[XX]]></ImageUrl>
        <Weight>${item.Weight!}</Weight>
        <WeightUnits>${item.WeightUnits!}</WeightUnits>
        <Quantity>${item.quantity}</Quantity>
        <UnitPrice>${item.unitAmount}</UnitPrice>
        <Location><![CDATA[XX]]></Location>
          <Options>
          <#list item.features as feature>
            <#assign featureType = ec.entity.find("moqui.basic.Enumeration").condition("enumId",feature.type!).useCache(true).one()>
            <Option>
                <Name><![CDATA[${featureType.description!}]]></Name>
                <Value><![CDATA[${feature.description!}]]></Value>
                <Weight>XX</Weight>
            </Option>
          </#list>
        </Options>
      </Item>
      </#list>
    </Items>

  </Order>
 </#list>
 </Orders>