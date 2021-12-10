<?xml version=\"1.0\" encoding=\"utf-8\"?>
<Orders>
<#list orderParts as orders>
<#list orders.order_parts as part><#assign items = part.item_details><#assign shipping = part.shipping_details>
  <Order>
    <OrderID><![CDATA[${orders.orderId!}]]></OrderID>
    <OrderNumber><![CDATA[${orders.orderName!}]]></OrderNumber>
    <OrderDate>${orders.placedDate!}</OrderDate>
    <OrderStatus><![CDATA[${part.partStatusId}]]></OrderStatus>
    <LastModified>${part.lastModified}</LastModified>
    <#assign shipmentMethod = ec.entity.find("moqui.basic.Enumeration").condition("enumId",part.shipmentMethodEnumId!).useCache(true).one()>
    <ShippingMethod><![CDATA[${shipmentMethod.description!}]]></ShippingMethod>

    <#assign payment = ec.entity.find("mantle.account.payment.Payment").condition("orderId",orders.orderId).condition("orderPartSeqId",part.id).useCache(true).one()>
    <#if payment!="null">
        <#assign paymentMethod = ec.entity.find("mantle.account.method.PaymentMethod").condition("paymentMethodId",payment.paymentMethodId!).useCache(true).one()>
    </#if>
    <#assign paymentDescription = ec.entity.find("moqui.basic.Enumeration").condition("enumId",paymentMethod.paymentMethodTypeEnumId!).useCache(true).one()>

    <PaymentMethod><![CDATA[${paymentDescription.description!}]]></PaymentMethod>
    <CurrencyCode>${orders.currencyUom}</CurrencyCode>
    <OrderTotal>${part.partTotal}</OrderTotal>
    <TaxAmount>XX</TaxAmount>
    <ShippingAmount>${part.shippingCost}</ShippingAmount>
    <CustomerNotes><![CDATA[${part.shippingInstructions}]]></CustomerNotes>
    <InternalNotes><![CDATA[${part.shippingInstructions}]]></InternalNotes>
    <Gift>${part.isGift}</Gift>
    <GiftMessage>${part.giftMessage}</GiftMessage>
    <Customer>
      <CustomerCode><![CDATA[${orders.customer_details.email}]]></CustomerCode>
      <BillTo>
        <Name><![CDATA[${orders.billing_details.address.toName}]]></Name>
        <Company><![CDATA[XX]]></Company>
        <Phone><![CDATA[${orders.billing_details.phone.contactNumber!}]]></Phone>
        <Email><![CDATA[${orders.customer_details.email}]]></Email>
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
        <#assign dimension = ec.entity.find("mantle.product.ProductUomDimension").condition("productId",item.productId).condition("uomDimensionTypeId",'Weight').useCache(true).one()>
        <#assign units = ec.entity.find("moqui.basic.Uom").condition("uomId",dimension.uomId).useCache(true).one()>
        <SKU><![CDATA[${item.sku}]]></SKU>
        <Name><![CDATA[${item.product_name}]]></Name>
        <ImageUrl><![CDATA[XX]]></ImageUrl>
        <Weight>${dimension.value!}</Weight>
        <WeightUnits>${units.abbreviation!}</WeightUnits>
        <Quantity>${item.quantity}</Quantity>
        <UnitPrice>${item.unitAmount}</UnitPrice>
        <Location><![CDATA[XX]]></Location>
        <#assign featuresList = ec.service.sync().name("co.hotwax.oms.ProductServices.find#Products").parameter("productId", item.productId).call()>
          <Options>
          <#list featuresList.products[0].features as feature>
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
 </#list>
 </Orders>