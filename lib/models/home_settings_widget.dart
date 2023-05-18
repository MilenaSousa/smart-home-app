class HomeSettingsWidget {
  final String label;
  final String value;
  final String suffix;
  final bool activated;
  final int iconCode;

  HomeSettingsWidget(
      {required this.label,
      required this.value,
      required this.suffix,
      required this.activated,
      required this.iconCode});

  factory HomeSettingsWidget.fromJson(Map<String, dynamic> json) {
    return HomeSettingsWidget(
        label: json['label'],
        value: json['value'],
        suffix: json['suffix'],
        activated: json['activated'],
        iconCode: json['iconCode']);
  }
}
