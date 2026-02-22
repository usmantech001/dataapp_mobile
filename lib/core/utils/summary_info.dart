import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/giftcard_txn.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';

List<SummaryItem> getSummaryItems(TransactionType type,
    {ServiceTxn? transInfo, GiftcardTxn? giftcardInfo}) {
  List<SummaryItem> items = [];
  List<SummaryItem> paymentInfoItems = [
    SummaryItem(
        title: 'Paymnet Date',
        name: formatDateShort(transInfo?.createdAt ??
                giftcardInfo?.created_at ??
                DateTime.now()) ??
            ""),
    SummaryItem(
        title: 'Paymnet Time',
        name: formatDateShortWithTime(transInfo?.createdAt ??
                giftcardInfo?.created_at ??
                DateTime.now()) ??
            ""),
    SummaryItem(
      title: 'Payment Method',
      name: 'Data App Wallet',
    ),
    SummaryItem(
      title: 'Payment Status',
      name: transInfo?.status.name ?? giftcardInfo?.status.name ?? "",
      hasDivider: true,
    ),
    SummaryItem(title: 'Amount', name: '₦${transInfo?.amount}')
  ];
  if (transInfo?.purpose == ServicePurpose.airtime ||
      transInfo?.purpose == ServicePurpose.internationalAirtime) {
    List<SummaryItem> airtimeItems = [
      SummaryItem(title: 'Network', name: transInfo?.meta.provider?.name ?? ""),
      SummaryItem(
        title: 'Phone Number',
        name: transInfo?.meta.customer?.phone ?? "",
        hasDivider: true,
      ),
    ];
    items = [...airtimeItems, ...paymentInfoItems];
  }
  if (transInfo?.purpose == ServicePurpose.data ||
      transInfo?.purpose == ServicePurpose.internationalData) {
    List<SummaryItem> airtimeItems = [
      SummaryItem(title: 'Network', name: transInfo?.meta.provider?.name ?? ""),
      SummaryItem(
          title: 'Phone Number', name: transInfo?.meta.customer?.phone ?? ""),
      SummaryItem(
        title: 'Data Plan',
        name: transInfo?.meta.product?.name ?? "",
        hasDivider: true,
      ),
    ];
    items = [...airtimeItems, ...paymentInfoItems];
  }

  if (transInfo?.purpose == ServicePurpose.electricity) {
    String token = (transInfo?.meta.token ?? "")
        .replaceAll('Token', '')
        .replaceAll(":", "")
        .trim();
    List<SummaryItem> electricityItems = [
      SummaryItem(
          title: 'Electricity Provider',
          name: transInfo?.meta.provider?.name ?? ""),
      SummaryItem(
        title: 'Meter Number',
        name: transInfo?.meta.customer?.meterNumber ?? "",
      ),
      SummaryItem(
        title: 'Token',
        name: token,
        hasDivider: true,
      ),
    ];
    items = [...electricityItems, ...paymentInfoItems];
  }

  if (transInfo?.purpose == ServicePurpose.tvSubscription) {
    List<SummaryItem> cableItems = [
      SummaryItem(
          title: 'TC/Cable Provider',
          name: transInfo?.meta.provider?.name ?? ""),
      SummaryItem(
        title: 'Product',
        name: transInfo?.meta.product?.name ?? "",
      ),
      SummaryItem(
        title: 'Smartcard Number',
        name: transInfo?.meta.customer?.smartcardNumber ?? "",
        hasDivider: true,
      ),
    ];
    items = [...cableItems, ...paymentInfoItems];
  }

  if (transInfo?.purpose == ServicePurpose.betting) {
    List<SummaryItem> bettingItems = [
      SummaryItem(
          title: 'Service Provider',
          name: transInfo?.meta.provider?.name ?? ""),
      SummaryItem(
        title: 'Bet ID / Phone Number',
        name: transInfo?.meta.customer?.customer_id ?? "",
        hasDivider: true,
      ),
      //SummaryItem(title: 'Bet ID / Phone Number', name: transInfo?.meta.customer.??"", hasDivider: true,),
    ];
    items = [...bettingItems, ...paymentInfoItems];
  }

  if (transInfo?.purpose == ServicePurpose.education) {
    List<SummaryItem> bettingItems = [
      SummaryItem(
          title: 'Service Provider',
          name: transInfo?.meta.provider?.name ?? ""),
      SummaryItem(
        title: 'Number',
        name: transInfo?.meta.customer?.registrationNumber ?? "",
        hasDivider: true,
      ),
      //SummaryItem(title: 'Bet ID / Phone Number', name: transInfo?.meta.customer.??"", hasDivider: true,),
    ];
    items = [...bettingItems, ...paymentInfoItems];
  }

  if (transInfo?.purpose == ServicePurpose.deposit) {
    List<SummaryItem> depositItems = [
      SummaryItem(title: 'Amount', name: transInfo?.amount.toString() ?? ""),
      SummaryItem(
        title: 'Depositor Name',
        name: capitalize(transInfo?.provider) ?? "",
        hasDivider: true,
      ),
      //SummaryItem(title: 'Bet ID / Phone Number', name: transInfo?.meta.customer.??"", hasDivider: true,),
    ];
    items = [...depositItems, ...paymentInfoItems];
  }

  if (giftcardInfo != null) {
    List<SummaryItem> giftItems = [
      SummaryItem(
          title: 'Giftcard Category"',
          name: giftcardInfo.gift_card?.category?.name ?? "" ?? ""),
      SummaryItem(
        title: "Giftcard Product",
        name: giftcardInfo.gift_card?.name ?? "",
      ),
      SummaryItem(
        title: "Rate",
        name: formatCurrency(giftcardInfo.rate),
      ),
      SummaryItem(
        title: "Unit",
        name: giftcardInfo.quantity.toString(),
      ),
      SummaryItem(
        title: "Giftcard Amount",
        name: formatCurrency(giftcardInfo.amount,
            code: giftcardInfo.gift_card?.currency ?? ""),
      ),
      SummaryItem(
        title: "Giftcard Number",
        name: giftcardInfo.cards.first.cardNumber,
      ),

      SummaryItem(
        title: "Amount In Naira",
        name: formatCurrency(giftcardInfo.ngn_amount, code: "NGN"),
      ),

      SummaryItem(
        title: "Service Charge",
        name: formatCurrency(giftcardInfo.service_charge,
            code: giftcardInfo.gift_card?.currency ?? ""),
      ),
      //SummaryItem(title: 'Bet ID / Phone Number', name: transInfo?.meta.customer.??"", hasDivider: true,),
    ];
    items = [...giftItems, ...paymentInfoItems];
  }

  return items;
}

enum TransactionType {
  airtime,
  data,
  electricity,
  cable,
  intlAirtime,
  intlData,
  giftcard,
  betting,
  withdraw,
  epin
}
