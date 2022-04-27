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
              <OrderDate>${ec.l10n.format(orderHeaderAndPart.placedDate,'MM/dd/yyyy HH:MM')}</OrderDate>
              <OrderStatus>
                 <![CDATA[${part.partStatusId!}]]>
              </OrderStatus>
              <LastModified>${ec.l10n.format(orderHeaderAndPart.lastUpdatedStamp,'MM/dd/yyyy HH:MM')}</LastModified>
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
              <Gift>
                <#if orderHeaderAndPart.isGift == "Y">
                 <![CDATA[${"true"}]]>
                <#else>
                 <![CDATA[${"false"}]]>
                </#if>
              </Gift>
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
                        <#assign geoState = ec.entity.find("moqui.basic.Geo").condition("geoId",shipAddress.stateProvinceGeoId!).useCache(true).one()>
                        <#assign geoCountry = ec.entity.find("moqui.basic.Geo").condition("geoId",shipAddress.countryGeoId!).useCache(true).one()>
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
                    <#if geoState??>
                        <State>
                           <![CDATA[${geoState.geoCodeAlpha2!}]]>
                        </State>
                    </#if>
                    <PostalCode>
                       <![CDATA[${shipAddress.postalCode!}]]>
                    </PostalCode>
                    <#if geoCountry??>
                        <Country>
                           <![CDATA[${geoCountry.geoCodeAlpha2!}]]>
                        </Country>
                    </#if>
                    <Phone>
                       <![CDATA[${shipAddress.contactNumber!}]]>
                    </Phone>
                 </ShipTo>
              </Customer>
              <Items>
                 <#list items as item>
                     <Item>
                        <SKU>
                           <![CDATA[${item.sku!}]]>
                        </SKU>
                        <Name>
                           <![CDATA[${item.product_name!}]]>
                        </Name>
                        <#assign productContent = ec.entity.find("mantle.product.ProductContent").condition("productId",item.productId).condition("productContentTypeEnumId",'PcntImageLarge').list()>
                        <#if !productContent.isEmpty()>
                            <#assign url = ec.resource.getLocationReference(productContent[0].contentLocation)>
                            <ImageUrl>
                               <![CDATA[${url!}]]>
                            </ImageUrl>
                        </#if>
                        <#assign dimension = ec.entity.find("mantle.product.ProductUomDimension").condition("productId",item.productId).condition("uomDimensionTypeId",'Weight').list()>
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
                        <#assign productFeaturesList = ec.entity.find("mantle.product.feature.ProductAndFeatureAndFeatureAppl").condition("productId",item.productId).selectField("productFeatureId,productFeatureTypeEnumId,productFeatureDescription").list()>
                        <#if !productFeaturesList.isEmpty()>
                            <Options>
                               <#list productFeaturesList as feature>
                               <#assign featureType = ec.entity.find("moqui.basic.Enumeration").condition("enumId",feature.productFeatureTypeEnumId!).condition("enumTypeId",'ProductFeatureType').useCache(true).one()>
                                   <Option>
                                      <Name>
                                         <![CDATA[${featureType.description!}]]>
                                      </Name>
                                      <Value>
                                         <![CDATA[${feature.productFeatureDescription!}]]>
                                      </Value>
                                      <#--
                                      <Weight>XX</Weight>
                                      -->
                                   </Option>
                               </#list>
                            </Options>
                        </#if>
                     </Item>
                 </#list>
                 <#assign discount = ec.entity.find("mantle.order.OrderItem").condition("orderId",order.orderId).condition("orderPartSeqId",part.id).condition("itemTypeEnumId",'ItemDiscount').list()>
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
