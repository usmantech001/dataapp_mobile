class ServiceStatus {
    StatusData? airtime;
    StatusData? airtimePrint;
    StatusData? betting;
    StatusData? data;
    StatusData? ePin;
    StatusData? electricity;
    StatusData? flight;
    StatusData? tv;
    StatusData? giftcards;
    StatusData? crypto;
    StatusData? fund;
    StatusData? withdraw;
    StatusData? transfer;
    StatusData? virtualCard;
    StatusData? internationalAirtime;
    StatusData? internationalData;

    ServiceStatus({
        this.airtime,
        this.airtimePrint,
        this.betting,
        this.data,
        this.ePin,
        this.electricity,
        this.flight,
        this.tv,
        this.giftcards,
        this.crypto,
        this.fund,
        this.withdraw,
        this.transfer,
        this.virtualCard,
        this.internationalAirtime,
        this.internationalData,
    });

    factory ServiceStatus.fromJson(Map<String, dynamic> json) => ServiceStatus(
        airtime: json["airtime"] == null ? null : StatusData.fromJson(json["airtime"]),
        airtimePrint: json["airtime-print"] == null ? null : StatusData.fromJson(json["airtime-print"]),
        betting: json["betting"] == null ? null : StatusData.fromJson(json["betting"]),
        data: json["data"] == null ? null : StatusData.fromJson(json["data"]),
        ePin: json["e-pin"] == null ? null : StatusData.fromJson(json["e-pin"]),
        electricity: json["electricity"] == null ? null : StatusData.fromJson(json["electricity"]),
        flight: json["flight"] == null ? null : StatusData.fromJson(json["flight"]),
        tv: json["tv"] == null ? null : StatusData.fromJson(json["tv"]),
        giftcards: json["giftcards"] == null ? null : StatusData.fromJson(json["giftcards"]),
        crypto: json["crypto"] == null ? null : StatusData.fromJson(json["crypto"]),
        fund: json["fund"] == null ? null : StatusData.fromJson(json["fund"]),
        withdraw: json["withdraw"] == null ? null : StatusData.fromJson(json["withdraw"]),
        transfer: json["transfer"] == null ? null : StatusData.fromJson(json["transfer"]),
        virtualCard: json["virtual-card"] == null ? null : StatusData.fromJson(json["virtual-card"]),
        internationalAirtime: json["international-airtime"] == null ? null : StatusData.fromJson(json["international-airtime"]),
        internationalData: json["international-data"] == null ? null : StatusData.fromJson(json["international-data"]),
    );

    Map<String, dynamic> toJson() => {
        "airtime": airtime?.toJson(),
        "airtime-print": airtimePrint?.toJson(),
        "betting": betting?.toJson(),
        "data": data?.toJson(),
        "e-pin": ePin?.toJson(),
        "electricity": electricity?.toJson(),
        "flight": flight?.toJson(),
        "tv": tv?.toJson(),
        "giftcards": giftcards?.toJson(),
        "crypto": crypto?.toJson(),
        "fund": fund?.toJson(),
        "withdraw": withdraw?.toJson(),
        "virtual-card": virtualCard?.toJson(),
        "transfer": transfer?.toJson(),
        "international-airtime": internationalAirtime?.toJson(),
        "international-data": internationalData?.toJson(),
    };
}

class StatusData {
    bool? status;
    String? message;
    String? value;

    StatusData({
        this.status,
        this.message,
        this.value,
    });

    factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        value: json["value"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "value": value,
    };
}
