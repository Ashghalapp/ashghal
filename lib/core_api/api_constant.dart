// ignore_for_file: non_constant_identifier_names

class ApiConstants {
  static const String baseUrl = "http://10.0.2.2:8000/api/";
  // static const String baseUrl = "http://192.168.128.175:8000/api/";
  static const String channelsAutherizingUrl = "${baseUrl}broadcasting/auth";
  //   static const String channelsAutherizingUrl =
  // "http://192.168.0.192:8000/api/broadcasting/auth";
  // static const String baseUrl = "http://localhost:8000/api/";
  // static const String baseUrl = "https://jsonplaceholder.typicode.com/";

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'x_api_key': 'z5Y4eX4SGe1Be1sLhiHc40Ezw8zdVI',
    'x_language': 'en'
  };

  static String AUTH_ENDPOINT = "auth/";
  static String CHECK_EMAIL = "${AUTH_ENDPOINT}check-email";
  static String REGISTER_USER = "${AUTH_ENDPOINT}register-user";
  // static String REGISTER_PROVIDER = "${AUTH_ENDPOINT}register-provider";
  static String LOGIN = "${AUTH_ENDPOINT}login";
  static String LOGOUT = "${AUTH_ENDPOINT}logout";
  static String SEND_EMAIL_VERIFICATION_CODE =
      "${AUTH_ENDPOINT}send-email-verification-code";
  static String VALIDATE_EMAIL_VERIFICATION_CODE =
      "${AUTH_ENDPOINT}validate-email-verification-code";
  // static String VERIFY_EMAIL = "${AUTH_ENDPOINT}verify-email";
  // static String RESEND_EMAIL_VERIFICATION_CODE = "${AUTH_ENDPOINT}resend-email-verification-code";

  static String FORGET_PASSWORD = "${AUTH_ENDPOINT}forget-password";
  // static String RESEND_FORGET_PASSWORD_CODE = "${AUTH_ENDPOINT}resend-forget-password-code";
  static String VALIDATE_RESET_PASSWORD_BY_EMAIL_CODE =
      "${AUTH_ENDPOINT}validate-reset-password-email-code";
  static String RESET_PASSWORD = "${AUTH_ENDPOINT}reset-password";

  static String ADD_OR_CHANGE_PHONE = "${AUTH_ENDPOINT}add-or-change-phone";
  static String ADD_OR_CHANGE_EMAIL = "${AUTH_ENDPOINT}add-or-change-email";
}

class ChannelsEventsNames {
  static const String userStateUpdatedChannel = 'presence-user.state.updated';
  static const String userStateUpdatedEvent = 'user.state.updated.event';
  static const String chatChannelName = 'private-chat.';
  static const String messageSentEventName = 'message.sent';
  static const String messageReceivedEventName = 'message.received';
  static const String messageReadEventName = 'message.read';
  static const String typingEventName = 'client-user.typing.state';
}
