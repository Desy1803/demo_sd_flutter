class Constants {

 static final String ADDRESS_STORE_SERVER = "localhost:8090";
  static final String ADDRESS_AUTHENTICATION_SERVER = "localhost:8080";

  //companies
  static final String GETREQUEST_VIEWALLCOMPANIES="api/stocks/companies";

  static final String GETREQUEST_GETCOMPANIESBYSEARCH="/api/stocks/companies/search";

  static final String GETREQUEST_GETCOMPANYFUNDAMENTALDATA="api/stocks/getFundamentalData";

  static final String GETREQUEST_GETCOMPANYBALANCESHEET="api/stocks/getBalanceSheet";

  static const String GETREQUEST_GETGLOBALMARKETSTATUS = "/api/stocks/getGlobalStatus";

  static const String GET_REQUEST_GETLATESTINFO="api/stocks/latest-info";

  
  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";

  // authentication

  static final String POSTREQUEST_LOGIN="/api/users/security/login";
  static final String POSTREQUEST_REFRESHTOKEN="api/users/security/refresh";
  static final String POSTREQUEST_REGISTRATION="api/users/security/register";
  static final String SEND_VERIFICATION_EMAIL="api/users/security/send-verification-email";
  static final String VERIFICATION_EMAIL="api/users/security/verified-email";
  static final String PASSWORD_RESET="api/users/security/forgot-password";
  static final String UPDATE_USER="api/users/security/update-user";
  static final String DELET_USER= "api/users/security";
  static final String GETREQUEST_USER="api/users/security/get-user";
  static final String LOGOUT="api/users/security/log-out";
    //Articles
  static final String ALL_PUBLIC_ARTICLES="api/articles/public";
  static final String CREATE_ARTICLE_AUTH="api/articles";
  static final String UPDATE_ARTICLE_AUTH="api/articles/update";
  static final String DELETE_ARTICLE_AUTH="api/articles/delete";
  static final String GETREQUEST_GETARTICLEBYUSER="api/articles/user";
  static final String GETIMAGE_ARTICLE="api/articles/get-image";

  static final String SETIMAGE_ARTICLE="api/articles/set-image";
  static final String POSTREQUEST_CREATEARTICLEWITHAI="api/ai";

}