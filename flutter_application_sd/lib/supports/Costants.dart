class Constants {

 static final String ADDRESS_STORE_SERVER = "localhost:8090";
  static final String ADDRESS_AUTHENTICATION_SERVER = "localhost:8080";

  //companies
  static final String GETREQUEST_VIEWALLCOMPANIES="/api/stocks/companies";

  static final String GETREQUEST_GETCOMPANIESBYSEARCH="/api/stocks/companies/search";

  static final String GETREQUEST_GETCOMPANYFUNDAMENTALDATA="api/stocks/getFundamentalData";

  static final String GETREQUEST_GETCOMPANYBALANCESHEET="api/stocks/getBalanceSheet";

  static final String GETREQUEST_GETGLOBALMARKETSTATUS = "/api/stocks/getGlobalStatus";
  
  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";

  // authentication

  static final String POSTREQUEST_LOGIN="/api/users/security/login";
  static final String POSTREQUEST_REFRESHTOKEN="api/users/security/refresh";
  static final String POSTREQUEST_REGISTRATION="api/users/security/register";
  static final String SEND_VERIFICATION_EMAIL="api/users/security/send-verification-email";
  static final String VERIFICATION_EMAIL="api/users/security/verified-email";
  static final String PASSWORD_RESET="api/users/security/forgot-password";
  //Articles
  static final String ALL_PUBLIC_ARTICLES="api/articles/public";
  static final String CREATE_ARTICLE_AUTH="api/articles";
  static final String UPDATE_ARTICLE_AUTH="api/articles/update";
  static final String DELETE_ARTICLE_AUTH="api/articles/delete";
  static final String GETREQUEST_GETARTICLEBYUSER="api/articles/user";
}