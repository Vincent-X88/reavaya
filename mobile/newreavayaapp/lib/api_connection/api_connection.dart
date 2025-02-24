class API {
  //static const hostConnect = 'http://192.168.91.5:8080/api_reavaya';

  static const hostConnect = 'http://10.126.32.240:8080/api_reavaya';

  // Other API endpoints...
  static const validateEmail = '$hostConnect/user/validate_email.php';
  static const register = '$hostConnect/user/register.php';
  static const login = '$hostConnect/user/login.php';

  static const updatePoints = '$hostConnect/user/update_points.php';

  static const updateAccount = '$hostConnect/user/update_account.php';

  static const qrScanner = '$hostConnect/user/db.php';
  static const fetchStatistics = '$hostConnect/user/fetch_statistics.php';
  static const submitFeedback = '$hostConnect/user/submit_feedback.php';
  static const fetchUserInfo = '$hostConnect/user/fetch_user_info.php';
  static const deletePassengerAccount = '$hostConnect/user/deletePassengerAccount.php';
  static const fetchCoordinates = '$hostConnect/user/fetch_coordinates.php';
  static const pickupPoints = '$hostConnect/user/pickup_points.php';
  static const destinations = '$hostConnect/user/destinations.php';
  static const fetchNotifications = '$hostConnect/user/fetch_notifications.php';
  static const notifications = '$hostConnect/user/notifications.php';
  static const fetchPoints = '$hostConnect/user/fetch_points.php';
}
