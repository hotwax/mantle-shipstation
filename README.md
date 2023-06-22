# mantle-shipstation
ShipStation shipping gateway integration 

### How to setup

- clone moqui-framework
`git clone https://github.com/moqui/moqui-framework.git`

- go to moqui-framework directory
`cd moqui-framework`

- clone moqui-runtime
`git clone https://github.com/moqui/moqui-runtime.git runtime`

- go to runtime/component directory
`cd runtime/component`

- clone mantle
`git clone https://github.com/hotwax/mantle.git`

- clone shipstation
`git clone https://github.com/hotwax/mantle-shipstation.git`

- Use following command to load data
`./gradlew load`


######ShipStation Integration for shipping rates, create labels, and void label. In this Integration we worked on staging environment. So, the rates may vary from production evironment.
###To simplify:

Load the setup data in data/ShipStationSetupData.xml Load the demo configuration data in data/ShipStationZaaDemoData.xml or create your own configuration and load it; if you use the demo data, add your API token (SgoApiToken).

~ get#ShippingRates service: API path: https://ssapi.shipstation.com/shipments/getrates This API call is to get shipping rates for your multiple carrier and service options. Display these at a checkout to let your customers choose the fastest, cheapest, or most-trusted route when you ship your products. At minimum, a Rate request requires a delivery location and information on the parcels being delivered. However, different couriers and delivery methods can require additional fields to satisfy their requirements. ShipStation requires all requests to be in JSON format, so this header should always be set to application/json.

~ post#CreateLabel service : API path: https://ssapi.shipstation.com/shipments/createlabel Set the content type header to application/json and the API Key of your ShipStation. This call uses the request Body to be in json format. After successful service call, you will receive an HTTP response that included the label details.

~ put#VoidLabel service: API path: https://ssapi.shipstation.com/shipments/voidlabel You will need a 'shipment_id' from another Label Request to void a label. If the Label has left the originating facility and is in route to the destination the void label request will be denied. If the Label is too old to be voided, this request will be denied. If the Label has been scanned in, at the originating facility then it will also b denied.