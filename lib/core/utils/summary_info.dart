import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';

List<SummaryItem> getSummaryItems(ServiceTxn transInfo, TransactionType type){
  List<SummaryItem> items = [];
  List<SummaryItem> paymentInfoItems = [
    SummaryItem(title: 'Paymnet Date', name: formatDateShort(transInfo.createdAt?? DateTime.now())??""),
    SummaryItem(title: 'Paymnet Time', name: formatDateShortWithTime(transInfo.createdAt?? DateTime.now())??""),
    SummaryItem(title: 'Payment Method', name: 'Data App Wallet',),
    SummaryItem(title: 'Payment Status', name: transInfo.status.name??"", hasDivider: true,),
    SummaryItem(title: 'Amount', name: '₦${transInfo.amount}')
  ];
  if(type == TransactionType.airtime || type == TransactionType.data){
    List<SummaryItem> airtimeItems = [
      SummaryItem(title: 'Network', name: transInfo.meta.provider?.name??""),
      SummaryItem(title: 'Phone Number', name: transInfo.meta.customer?.phone??"", hasDivider: true,),
    ];
    items = [...airtimeItems, ...paymentInfoItems];
  }

  if(type == TransactionType.electricity){
    List<SummaryItem> electricityItems = [
      SummaryItem(title: 'Electricity Provider', name: transInfo.meta.provider?.name??""),
      SummaryItem(title: 'Meter Number', name: transInfo.meta.customer?.meterNumber??"", hasDivider: true,),
    ];
    items = [...electricityItems, ...paymentInfoItems];
  }

  if(type == TransactionType.cable){
    List<SummaryItem> cableItems = [
      SummaryItem(title: 'TC/Cable Provider', name: transInfo.meta.provider?.name??""),
      SummaryItem(title: 'Package Type', name: transInfo.meta.customer?.meterNumber??"", hasDivider: true,),
    ];
    items = [...cableItems, ...paymentInfoItems];
  }

  if(type == TransactionType.betting){
    List<SummaryItem> bettingItems = [
      SummaryItem(title: 'Service Provider', name: transInfo.meta.provider?.name??""),
      SummaryItem(title: 'Bet ID / Phone Number', name: transInfo.meta.customer?.phone??"", hasDivider: true,),
      //SummaryItem(title: 'Bet ID / Phone Number', name: transInfo.meta.customer.??"", hasDivider: true,),
    ];
    items = [...bettingItems, ...paymentInfoItems];
  }

  if(type == TransactionType.epin){
    List<SummaryItem> bettingItems = [
      SummaryItem(title: 'Service Provider', name: transInfo.meta.provider?.name??""),
      SummaryItem(title: 'Number', name: transInfo.meta.customer?.phone??"", hasDivider: true,),
      //SummaryItem(title: 'Bet ID / Phone Number', name: transInfo.meta.customer.??"", hasDivider: true,),
    ];
    items = [...bettingItems, ...paymentInfoItems];
  }

  return items;

}



enum TransactionType{
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