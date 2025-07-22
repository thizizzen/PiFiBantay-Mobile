class NavigationService {
  static Function? _goToAlertsTab;

  static void setGoToAlerts(Function callback) {
    _goToAlertsTab = callback;
  }

  static void triggerGoToAlerts() {
    if (_goToAlertsTab != null) {
      _goToAlertsTab!();
    } else {
      print("Navigation callback not set. Cannot go to Alerts tab.");
    }
  }
}