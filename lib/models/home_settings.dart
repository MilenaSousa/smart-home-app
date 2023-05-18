import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_home_app/models/home_settings_widget.dart';

class HomeSettings {
  final bool generalStatusIsOk;
  final bool frontDoorIsLocked;
  final List<HomeSettingsWidget> widgetSettings;

  HomeSettings(
      {required this.generalStatusIsOk,
      required this.widgetSettings,
      required this.frontDoorIsLocked});

  factory HomeSettings.fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    List list = snapshot['widgets'] as List;
    List<HomeSettingsWidget> sttList = [];

    sttList = list.map((e) => HomeSettingsWidget.fromJson(e)).toList();

    return HomeSettings(
        generalStatusIsOk: snapshot['generalStatusIsOk'],
        frontDoorIsLocked: snapshot['frontDoorIsLocked'],
        widgetSettings: sttList);
  }
}
