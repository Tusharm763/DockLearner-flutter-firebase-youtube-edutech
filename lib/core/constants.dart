import 'dart:ui';
import 'package:hive/hive.dart';


List<Color> bgColor = [
  const Color.fromRGBO(78, 145, 151, 1),
  const Color.fromRGBO(212, 108, 117, 1),
  const Color.fromRGBO(233, 193, 146, 1),
  const Color.fromRGBO(108, 136, 225, 1),
  const Color.fromRGBO(78, 145, 151, 1),
];

String getYouTubeThumbnail(String videoID) => 'https://img.youtube.com/vi/$videoID/hqdefault.jpg';

String secToHHMMSS(sec) {
  int hours = sec ~/ 3600;
  int minutes = (sec % 3600) ~/ 60;
  int secs = sec % 60;

  if (hours == 0 && minutes == 0) {
    return "${secs}s";
  }
  if (hours == 0) {
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = secs.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = secs.toString().padLeft(2, '0');

  return "$hoursStr:$minutesStr:$secondsStr";
}

class SettingsService {
  static const String boxName = 'ALL';
  static late Box _box;

  // Settings keys
  static const String keyAutoPlay = 'AutoPlay';
  static const String keyAutoSave = 'AutoSave';
  static const String keyAccType = 'Role';

  // Initialize the Hive box
  static Future<void> init() async {
    _box = await Hive.openBox(boxName);

    // Set default values if they don't exist
    if (!_box.containsKey(keyAutoPlay)) {
      await _box.put(keyAutoPlay, false);
    }

    if (!_box.containsKey(keyAutoSave)) {
      await _box.put(keyAutoSave, 5);
    }

    if (!_box.containsKey(keyAccType)) {
      await _box.put(keyAccType, 'Student');
    }
  }

  // Get autoPlay setting
  static bool getAutoPlay() {
    return _box.get(keyAutoPlay, defaultValue: false);
  }

  // Set autoPlay setting
  static Future<void> setAutoPlay(bool value) async {
    await _box.put(keyAutoPlay, value);
  }

  // Get autoSave setting
  static int getAutoSave() {
    return _box.get(keyAutoSave, defaultValue: 5);
  }

  // Set autoSave setting
  static Future<void> setAutoSave(int value) async {
    await _box.put(keyAutoSave, value);
  }

  // Get account type
  static String getAccType() {
    return _box.get(keyAccType, defaultValue: 'Student');
  }

  // Set account type
  static Future<void> setAccType(String value) async {
    await _box.put(keyAccType, value);
  }

  // Listen for changes to a specific key
  static Stream<BoxEvent> watch(String key) {
    return _box.watch(key: key);
  }

  // Listen for changes to any key
  static Stream<BoxEvent> watchAll() {
    return _box.watch();
  }

  // Close the box
  static Future<void> close() async {
    await _box.close();
  }
}
