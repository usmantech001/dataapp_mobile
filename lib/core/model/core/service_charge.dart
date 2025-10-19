// To parse this JSON data, do
//
//     final serviceCharge = serviceChargeFromJson(jsonString);

import 'dart:convert';

ServiceCharge serviceChargeFromJson(String str) => ServiceCharge.fromJson(json.decode(str));

String serviceChargeToJson(ServiceCharge data) => json.encode(data.toJson());

class ServiceCharge {
    num? airtime;
    num? betting;
    num? data;
    num? ePin;
    num? electricity;
    num? tv;
    num? deposit;
    num? transfer;
    num? withdrawal;
    num? giftcard;
    num? virtualCardFundingUsd;
    num? virtualCardFundingNgn;
    num? virtualCardWithdrawalUsd;
    num? virtualCardWithdrawalNgn;



    ServiceCharge({
        this.airtime,
        this.betting,
        this.data,
        this.ePin,
        this.electricity,
        this.tv,
        this.deposit,
        this.transfer,
        this.withdrawal,
        this.giftcard,
        this.virtualCardFundingNgn,
        this.virtualCardFundingUsd,
        this.virtualCardWithdrawalNgn,
        this.virtualCardWithdrawalUsd,

    });

    factory ServiceCharge.fromJson(Map<String, dynamic> json) => ServiceCharge(
        airtime: json["airtime"],
        betting: json["betting"],
        data: json["data"],
        ePin: json["e-pin"],
        electricity: json["electricity"],
        tv: json["tv"],
        deposit: json["deposit"],
        transfer: json["transfer"],
        withdrawal: json["withdrawal"],
        giftcard: json["giftcard"] ??0,
        virtualCardFundingNgn: json['virtual_card_funding_ngn'] ?? 0,
        virtualCardFundingUsd: json['virtual_card_funding_usd'] ?? 0,
        virtualCardWithdrawalNgn: json['virtual_card_withdrawal_ngn'] ?? 0,
        virtualCardWithdrawalUsd: json['virtual_card_withdrawal_usd'] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "airtime": airtime,
        "betting": betting,
        "data": data,
        "e-pin": ePin,
        "electricity": electricity,
        "tv": tv,
        "deposit": deposit,
        "transfer": transfer,
        "withdrawal": withdrawal,
        "giftcard": giftcard,
      "virtual_card_withdrawal_usd": virtualCardFundingUsd,
      "virtual_card_withdrawal_ngn": virtualCardFundingNgn,
      "virtual_card_funding_usd": virtualCardFundingUsd,
      "virtual_card_funding_ngn": virtualCardFundingNgn,
    };
}
