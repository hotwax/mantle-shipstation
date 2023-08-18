# mantle-shipstation
ShipStation shipping gateway integration

######ShipStation Integration for shipping rates, create labels, and void label. In this Integration we worked on staging environment. So, the rates may vary from production evironment.
###To simplify:

Load the setup data in data/ShipStationSetupData.xml Load the demo configuration data in data/ShipStationZaaDemoData.xml or create your own configuration and load it; if you use the demo data, add your API token (SgoApiToken).

~ get#ShippingRates service: This API returns a rate as per the destination location and parcel attributes.

~ create#ShippingLabel service : This API will return labelData, pdf of label and shipmentId which can be use for track, refund or void a label.

~ void#ShippingLabel service: You will need a shipmentId from a Label Request to void a label. If the Label is too old to be voided this request will be denied.