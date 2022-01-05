<?xml version="1.0" encoding="utf-8"?>
<Orders>
   <#list orders as order>
   <#list order.order_parts as part>
   <#assign items = part.item_details!>
   <#assign shipping = part.shipping_details!>
   <#assign shipAddress = shipping.address!>
   <Order>
      <#assign orderHeaderAndPart = ec.entity.find("mantle.order.OrderHeaderAndPart").condition("orderId",order.orderId).condition("orderPartSeqId",part.id).one()>
      <OrderID>
         <![CDATA[${order.orderId!}]]>
      </OrderID>
      <OrderNumber>
         <![CDATA[${order.orderName!}]]>
      </OrderNumber>
      <OrderDate>${order.placedDate!}</OrderDate>
      <OrderStatus>
         <![CDATA[${part.partStatusId!}]]>
      </OrderStatus>
      <LastModified>${ec.l10n.format(orderHeaderAndPart.lastUpdatedStamp, 'yyyy-MM-dd HH:MM')}</LastModified>
      <#assign shipmentMethod = ec.entity.find("moqui.basic.Enumeration").condition("enumId",part.shipmentMethodEnumId!).useCache(true).one()>
      <ShippingMethod>
         <![CDATA[${shipmentMethod.description!}]]>
      </ShippingMethod>
      <#assign payment = ec.entity.find("mantle.account.payment.Payment").condition("orderId",order.orderId).condition("orderPartSeqId",part.id).list()>
      <#if !payment.isEmpty()>
      <#assign paymentMethod = ec.entity.find("mantle.account.method.PaymentMethod").condition("paymentMethodId",payment[0].paymentMethodId!).one()>
      <#assign paymentDescription = ec.entity.find("moqui.basic.Enumeration").condition("enumId",paymentMethod.paymentMethodTypeEnumId!).useCache(true).one()>
      <PaymentMethod>
         <![CDATA[${paymentDescription.description!}]]>
      </PaymentMethod>
      </#if>
      <CurrencyCode>${order.currencyUom!}</CurrencyCode>
      <OrderTotal>${orderHeaderAndPart.partTotal!}</OrderTotal>
      <#--
      <TaxAmount>XX</TaxAmount>
      -->
      <ShippingAmount>${part.shippingCost!}</ShippingAmount>
      <CustomerNotes>
         <![CDATA[${part.shippingInstructions!}]]>
      </CustomerNotes>
      <InternalNotes>
         <![CDATA[${part.shippingInstructions!}]]>
      </InternalNotes>
      <Gift>${orderHeaderAndPart.isGift!}</Gift>
      <GiftMessage>${orderHeaderAndPart.giftMessage!}</GiftMessage>
      <Customer>
         <CustomerCode>
            <![CDATA[${order.customer_details.email!}]]>
         </CustomerCode>
         <BillTo>
            <Name>
               <![CDATA[${order.billing_details.address.toName!}]]>
            </Name>
            <#--
            <Company>
               <![CDATA[XX]]>
            </Company>
            -->
            <Phone>
               <![CDATA[${order.billing_details.phone.contactNumber!}]]>
            </Phone>
            <Email>
               <![CDATA[${order.customer_details.email!}]]>
            </Email>
         </BillTo>
         <ShipTo>
            <#if !shipAddress.isEmpty()>
            <#assign geo = ec.entity.find("moqui.basic.Geo").condition("geoId",shipAddress.stateProvinceGeoId!).useCache(true).one()>
            </#if>
            <Name>
               <![CDATA[${shipAddress.toName!}]]>
            </Name>
            <#--
            <Company>
               <![CDATA[XX]]>
            </Company>
            -->
            <Address1>
               <![CDATA[${shipAddress.address1!}]]>
            </Address1>
            <Address2>${shipAddress.address2!}</Address2>
            <City>
               <![CDATA[${shipAddress.city!}]]>
            </City>
            <#if geo??>
            <State>
               <![CDATA[${geo.geoCodeAlpha2!}]]>
            </State>
            </#if>
            <PostalCode>
               <![CDATA[${shipAddress.postalCode!}]]>
            </PostalCode>
            <Country>
               <![CDATA[${shipAddress.countryGeoId!}]]>
            </Country>
            <Phone>
               <![CDATA[${shipAddress.contactNumber!}]]>
            </Phone>
         </ShipTo>
      </Customer>
      <Items>
         <#list items as item>
         <Item>
            <#assign dimension = ec.entity.find("mantle.product.ProductUomDimension").condition("productId",item.productId).condition("uomDimensionTypeId",'Weight').list()>
            <SKU>
               <![CDATA[${item.sku!}]]>
            </SKU>
            <Name>
               <![CDATA[${item.product_name!}]]>
            </Name>
            <#assign productContent = ec.entity.find("mantle.product.ProductContent").condition("productId",item.productId).condition("productContentTypeEnumId",'PcntImageLarge').list()>
            <#if !productContent.isEmpty()>s
            <#assign url = ec.resource.getLocationReference(productContent[0].contentLocation)>
            <ImageUrl>
               <![CDATA[${url!}]]>
            </ImageUrl>
            </#if>
            <#if !dimension.isEmpty()>
            <#assign units = ec.entity.find("moqui.basic.Uom").condition("uomId",dimension[0].uomId).useCache(true).one()>
            <Weight>${dimension.value!}</Weight>
            <WeightUnits>${units.abbreviation!}</WeightUnits>
            </#if>
            <Quantity>${item.quantity!}</Quantity>
            <UnitPrice>${item.unitAmount!}</UnitPrice>
            <#--
            TODO: Provide value if exists
            <Location>
               <![CDATA[XX]]>
            </Location>
            -->
            <#assign featuresList = ec.service.sync().name("co.hotwax.oms.ProductServices.find#Products").parameter("productId", item.productId).call()>
            <Options>
               <#list featuresList.products[0].features as feature>
               <#assign featureType = ec.entity.find("moqui.basic.Enumeration").condition("enumId",feature.type!).condition("enumTypeId",'ProductFeatureType').useCache(true).one()>
               <Option>
                  <Name>
                     <![CDATA[${featureType.description!}]]>
                  </Name>
                  <Value>
                     <![CDATA[${feature.description!}]]>
                  </Value>
                  <#--
                  <Weight>XX</Weight>
                  -->
               </Option>
               </#list>
            </Options>
         </Item>
         </#list>
         <#assign discount = ec.entity.find("mantle.order.OrderItemDetail").condition("orderId",order.orderId).condition("orderPartSeqId",part.id).condition("itemTypeEnumId",'ItemDiscount').list()>
         <#if !discount.isEmpty()>
         <Item>
            <SKU></SKU>
            <Name>
               <![CDATA[${discount[0].itemDescription!}]]>
            </Name>
            <Quantity>${discount[0].quantity!}</Quantity>
            <UnitPrice>${discount[0].unitAmount!}</UnitPrice>
            <Adjustment>true</Adjustment>
         </Item>
         </#if>
      </Items>
   </Order>
   </#list>
   </#list>
</Orders>