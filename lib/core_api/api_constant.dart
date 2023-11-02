// ignore_for_file: non_constant_identifier_names

class ApiConstants {
  static const String baseUrl = "http://10.0.2.2:8000/api/";
  // static const String baseUrl = "http://192.168.62.108:8000/api/";
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

  static String GET_CATEGORIES = "category/get";

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

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///=========================================   Post Urls ===============================================
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  static String POST_ENDPOINT = "post/";
  static String GET_ALL_POSTS = "${POST_ENDPOINT}get";
  static String GET_RECENT_POSTS = "${POST_ENDPOINT}get-recent-posts";
  static String GET_ALL_ALIVE_POSTS = "${POST_ENDPOINT}get-alive-posts";
  static String GET_ALL_COMPLETE_POSTS = "${POST_ENDPOINT}get-complete-posts";
  static String GET_CATEGORY_POSTS = "${POST_ENDPOINT}get-category-posts";
  static String GET_USER_POSTS = "${POST_ENDPOINT}get-user-posts";
  static String GET_CURRENT_USER_POSTS =
      "${POST_ENDPOINT}get-current-user-posts";
  static String GET_SPECIFIC_POST = "${POST_ENDPOINT}get/";
  static String ADD_POST = "${POST_ENDPOINT}add";
  static String UPDATE_POST = "${POST_ENDPOINT}update";
  static String SEARCH_FOR_POSTS = "${POST_ENDPOINT}search";
  static String DELETE_POST = "${POST_ENDPOINT}delete/";
  static String DELETE_SOME_POST_MULTIMEDIA =
      "${POST_ENDPOINT}delete-some-multimedia";

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///============================== Comment and reply Urls =============================================
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  static String COMMENT_ENDPOINT = "comment/";
  static String GET_COMMENTS_AND_REPLIES = "${COMMENT_ENDPOINT}get";
  static String GET_POST_COMMENTS = "${COMMENT_ENDPOINT}get-post-comments";
  static String GET_COMMENT_REPLIES = "${COMMENT_ENDPOINT}get-comment-replies";
  static String GET_USER_COMMENTS = "${COMMENT_ENDPOINT}get-user-comments";
  static String GET_USER_COMMENTS_ON_POST =
      "${COMMENT_ENDPOINT}get-user-comments-on-post";
  static String GET_USER_REPLIES_ON_COMMENT =
      "${COMMENT_ENDPOINT}get-user-replies-on-comment";
  static String ADD_COMMENT_OR_REPLY = "${COMMENT_ENDPOINT}add";
  static String UPDATE_COMMENT_OR_REPLY = "${COMMENT_ENDPOINT}update";
  static String DELETE_COMMENT_OR_REPLY = "${COMMENT_ENDPOINT}delete/";
  static String DELETE_COMMENT_OR_REPLY_IMAGE =
      "${COMMENT_ENDPOINT}delete-image/";

  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///============================== User and FollowerUrls =============================================
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  static String USER_ENDPOINT = "user/";
  static String GET_CURRENT_USER = "${USER_ENDPOINT}current-user";
  static String GET_SPECIFIC_USER = "${USER_ENDPOINT}get/";
  static String UPDATE_USER = "${USER_ENDPOINT}update";
  static String CONVERT_CLIENT_TO_PROVIDER = "${USER_ENDPOINT}client-to-provider";
  static String CONVERT_PROVIDER_TO_CLIENT = "${USER_ENDPOINT}provider-to-client";
  static String CHECK_PASSWORD = "${USER_ENDPOINT}check-password/";
  static String CHANGE_PASSWORD = "${USER_ENDPOINT}change-password";

  static String GET_USER_FOLLOWERS = "${USER_ENDPOINT}get-followers";
  static String GET_USER_FOLLOWINGS = "${USER_ENDPOINT}get-following";
  static String FOLLOW_USER = "${USER_ENDPOINT}follow-user/";
  static String UNFOLLOW_USER = "${USER_ENDPOINT}unfollow-user/";
  /// cancel user from following you (current user)
  static String UNFOLLOW_ME = "${USER_ENDPOINT}unfollow-me/";
  static String SEARCH_FOR_USERS = "${USER_ENDPOINT}search";
  static String DELETE_USER_IMAGE = "${USER_ENDPOINT}delete-image";
  static String DELETE_ACCOUNT = "${USER_ENDPOINT}delete";
}

class ChannelsEventsNames {
  static const String userStateUpdatedChannel = 'presence-user.state.updated';
  static const String userStateUpdatedEvent = 'user.state.updated.event';
  static const String chatChannelName = 'private-chat.';
  static const String messageSentEventName = 'message.sent';
  static const String messageReceivedEventName = 'message.received';
  static const String messageReadEventName = 'message.read';
  static const String typingEventName = 'client-user.typing.state';
  static const String userChannelName = 'private-user.channel.';
  static const String newMessageUnknownConversationEvent =
      'message.sent.unknown.conversation';
}
