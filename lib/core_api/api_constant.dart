class ApiConstants {
  static const String baseUrl = "http://10.0.2.2:8000/api/";
  // static const String baseUrl = "https://jsonplaceholder.typicode.com/";

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'x_api_key': 'z5Y4eX4SGe1Be1sLhiHc40Ezw8zdVI',
    'x_language': 'en'
  };

  static String AUTH_ENDPOINT = "user/";
  static String REGISTER_USER = "${AUTH_ENDPOINT}register-user";
  static String REGISTER_PROVIDER = "${AUTH_ENDPOINT}register-provider";
  static String LOGIN = "${AUTH_ENDPOINT}login";
  static String LOGOUT = "${AUTH_ENDPOINT}logout";
  static String VERIFY_EMAIL = "${AUTH_ENDPOINT}verify-email";
  static String RESEND_EMAIL_VERIFICATION_CODE = "${AUTH_ENDPOINT}resend-email-verification-code";
  static String CHECK_EMAIL_EXIST = "${AUTH_ENDPOINT}check-email-exist/";
  static String RESEND_FORGET_PASSWORD_CODE = "${AUTH_ENDPOINT}resend-forget-password-code";
  static String FORGET_PASSWORD = "${AUTH_ENDPOINT}forget-password";
  static String VERIFY_RESET_PASSWORD_CODE = "${AUTH_ENDPOINT}verify-reset-password-code";
  static String RESET_PASSWORD = "${AUTH_ENDPOINT}reset-password";  
}
