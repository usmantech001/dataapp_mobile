class Discount {
    num? amount;
    num? discount;
    num? fee;

    Discount({
        this.amount,
        this.discount,
        this.fee,
    });

    factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        amount: json["amount"] ?? 0,
        discount: json["discount"] ?? 0,
        fee: json["fee"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "amount": amount ?? 0,
        "discount": discount ?? 0,
        "fee": fee ?? 0,
    };
}