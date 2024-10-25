class Market {
  final String marketType;
  final String region;
  final String primaryExchanges;
  final String localOpen;
  final String localClose;
  final String currentStatus;
  final String notes;

  Market({
    required this.marketType,
    required this.region,
    required this.primaryExchanges,
    required this.localOpen,
    required this.localClose,
    required this.currentStatus,
    required this.notes,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      marketType: json['market_type'] as String,
      region: json['region'] as String,
      primaryExchanges: json['primary_exchanges'] as String,
      localOpen: json['local_open'] as String,
      localClose: json['local_close'] as String,
      currentStatus: json['current_status'] as String,
      notes: json['notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'market_type': marketType,
      'region': region,
      'primary_exchanges': primaryExchanges,
      'local_open': localOpen,
      'local_close': localClose,
      'current_status': currentStatus,
      'notes': notes,
    };
  }
}
