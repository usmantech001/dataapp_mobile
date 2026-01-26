class SpendingAnalysisResponse {
  final String message;
  final SpendingAnalysisData data;

  SpendingAnalysisResponse({
    required this.message,
    required this.data,
  });

  factory SpendingAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return SpendingAnalysisResponse(
      message: json['message'],
      data: SpendingAnalysisData.fromJson(json['data']),
    );
  }
}

class SpendingAnalysisData {
  final String period; // "monthly" or "weekly"
  final SpendingSummary summary;
  final List<SpendingChart> chart;
  final List<ServiceBreakdown> serviceBreakdown;

  SpendingAnalysisData({
    required this.period,
    required this.summary,
    required this.chart,
    required this.serviceBreakdown,
  });

  factory SpendingAnalysisData.fromJson(Map<String, dynamic> json) {
    return SpendingAnalysisData(
      period: json['period'],
      summary: SpendingSummary.fromJson(json['summary']),
      chart: (json['chart'] as List)
          .map((e) => SpendingChart.fromJson(e))
          .toList(),
      serviceBreakdown: (json['service_breakdown'] as List)
          .map((e) => ServiceBreakdown.fromJson(e))
          .toList(),
    );
  }
}

class SpendingSummary {
  final String totalSpent;
  final String currency;
  final String timeframe;

  SpendingSummary({
    required this.totalSpent,
    required this.currency,
    required this.timeframe,
  });

  factory SpendingSummary.fromJson(Map<String, dynamic> json) {
    return SpendingSummary(
      totalSpent: json['total_spent'].toString(),
      currency: json['currency'],
      timeframe: json['timeframe'],
    );
  }
}

class SpendingChart {
  final String label;
  final String month;
  final String date;
  final String year;
  final double amount;

  SpendingChart({
    required this.label,
    required this.month,
    required this.year,
    required this.amount,
    required this.date
  });

  factory SpendingChart.fromJson(Map<String, dynamic> json) {
    return SpendingChart(
      label: json['label'],
      month: json['month']??"",
      date: json['date']??"",
      year: json['year']??"",
      amount: double.parse(json['amount'].toString()),
    );
  }
}

class ServiceBreakdown {
  final String service;
  final double amount;
  final double percentage;

  ServiceBreakdown({
    required this.service,
    required this.amount,
    required this.percentage,
  });

  factory ServiceBreakdown.fromJson(Map<String, dynamic> json) {
    return ServiceBreakdown(
      service: json['service'],
      amount: double.parse(json['amount'].toString()),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
