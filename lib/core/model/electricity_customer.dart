// create a model for the customer

class ElectricityCustomer {
  final String customerName;
  final String meterNumber;
  final String address;
  final String arrears;

const ElectricityCustomer({
  required this.customerName,
  required this.meterNumber,
  required this.address,
  required this.arrears,
  });

      factory ElectricityCustomer.fromJson(Map<String, dynamic> json) => ElectricityCustomer(
        customerName: json[ 'customer_name' ] ?? "",
        meterNumber: json["meter_number"]?? "",
        address: json["address"] ?? "",
        arrears: json["arrears"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'meter_number': meterNumber,
        'address': address,
        'arrears': arrears,
    };}