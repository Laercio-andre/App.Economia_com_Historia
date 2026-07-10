import "package:shared_preferences/shared_preferences.dart";

/// Repositório simples de definições, persistido localmente.
/// Pronto para, no futuro, ser substituído por sincronização remota.
class SettingsRepository {
  static const _kPushNotifications = "push_notifications";
  static const _kThemeMwangole = "theme_mwangole";
  static const _kOfflineMode = "offline_mode";

  Future<bool> getPushNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kPushNotifications) ?? true;
  }

  Future<void> setPushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPushNotifications, value);
  }

  Future<bool> getThemeMwangole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kThemeMwangole) ?? true;
  }

  Future<void> setThemeMwangole(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kThemeMwangole, value);
  }

  Future<bool> getOfflineMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOfflineMode) ?? false;
  }

  Future<void> setOfflineMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOfflineMode, value);
  }
}
