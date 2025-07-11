class AppStrings {
//general
  static const String ar = "ar";
  static const String en = "en";
  static const String english = "English";
  static const String arabic = "العربية";
  static const String cancel = "cancel";
  static const String noInternet = "noInternet";
  static const String userNotFound = "user_not_found";
  static const String wrongPassword = "wrong_password";
  static const String emailInUse = "email_already_in_use";
  static const String weakPassword = "weak_password";
  static const String unknownError = "unknown_error";
  static const String wrongEmailOrPass = "wrongEmailOrPass";

  static const List<String> noRouteFound = [
    "ما هذا المكان!",
    "يبدوا ان هنالك خطأ ما!"
  ];

// text validation

  static const String pleaseEnterYourUsername = "pleaseEnterYourUsername";
  static const String pleaseEnterYourEmail = "pleaseEnterYourEmail";
  static const String pleaseEnterAValidEmail = "pleaseEnterAValidEmail";
  static const String pleaseEnterYourPass = "pleaseEnterYourPass";
  static const String passwordMustBe = "passwordMustBe";

  // onboarding
  static const String onboardingOneTitle = "onboardingOneTitle";
  static const String onboardingOneDescription = "onboardingOneDescription";
  static const String onboardingTwoTitle = "onboardingTwoTitle";
  static const String onboardingTwoDescription = "onboardingTwoDescription";
  static const String onboardingThreeTitle = "onboardingThreeTitle";
  static const String onboardingThreeDescription = "onboardingThreeDescription";
  static const String next = "Next";
  static const String getStarted = "getStarted";

  // images
  static const String onboardingOneImage = "assets/images/onboarding1.png";
  static const String onboardingTwoImage = "assets/images/onboarding2.png";
  static const String onboardingThreeImage = "assets/images/onboarding3.jpeg";
  static const String loginImage = "assets/images/loginuser.jpg";
  static const String homeImage = "assets/images/pivot.jpg";
  static const String waterImage = "assets/images/water.png";
  static const String statisticsImage = "assets/images/statistics.jpg";
  static const String weedsImage = "assets/images/weeds.png";
  static const String waterPumpBackground = "assets/images/pivot water.jpg";
  static const String smartphoneDetection =
      "assets/images/smartphone_detection.png";

  // Login
  static const String login = "login";
  static const String loginDescription = "loginDescription";
  static const String createAccount = "createAccount";
  static const String email = "email";
  static const String password = "password";
  static const String welcomeBack = "welcomeBack";
  static const String dontHaveAccount = "dontHaveAccount";
  static const String yourPassword = "yourPassword";
  static const String yourEmail = "yourEmail";
  static const String yourName = "yourName";

  static const String signup = "signup";
  static const String register = "register";
  static const String username = "username";
  static const String singupDescription = "singupDescription";
  static const String haveAccount = "haveAccount";

  // Home

  static const String waterPump = "waterPump";
  static const String welcomeText = "welcomeText";
  static const String weedDetection = "weedDetection";
  static const String statisticsAndResults = "statisticsAndResults";
  static const String weedCardDesc = "weedCardDesc";
  static const String pumpCardDesc = "pumpCardDesc";
  static const String volume = "volume";
  static const String liveCameraError = "liveCameraError";

//water pump
  static const String turnOn = "turnOn";
  static const String turnOff = "turnOff";
  static const String theDeviceNowIs = "theDeviceNowIs";
  static const String working = "working";
  static const String notWorking = "notWorking";
  static const String waterTank = "waterTank";
  static const String pump = "Pump";

  // live view camera

  static const String farmMonitoring = "farmMonitoring";
  static const String farmMonitoringDescription = "farmMonitoringDescription";

  // motor
  static const String pivotMotor = "pivotMotor";
  static const String motorImage = "assets/images/pivot_motor2.png";
  static const String motorSpeed = "motorSpeed";
  static const String motorNowIs = "motorNowIs";
  static const String motorWorking = "motorWorking";
  static const String motorNotWorking = "motorNotWorking";
  static const String motorDescription = "motorDescription";
  static const String retry = "retry";

  // weeds detection
  static const String noPredection = "noPredection";
  static const String predectionError = "predectionError";
  static const String chooseImageSource = "chooseImageSource";
  static const String camera = "camera";
  static const String gallery = "gallery";
  static const String noImageSelected = "noImageSelected";
  static const String imageError = "imageError";
  static const String predection = "predection";
  static const String pickImage = "pickImage";
  static const String description = "description";
  static const String newText = "newText";
  static const String makeSureImageInFocus = "makeSureImageInFocus";

  // soil moisture

  static const String status = "status";
  static const String moisture = "moisture";
  static const String bad = "bad";
  static const String good = "good";
  static const String stable = "stable";
  //errors
  static const String generalError = "generalError";
  static const String locTryAgain = "try_again";
  static const String locLoginNotAvailable = "login_not_available";
  static const String locTagAlreadyWritten = "tag_already_written";
  static const String locLoginAuthError = "login_auth_error";
  static const String locLoginAuthErrorMessage = "locLoginAuthErrorMessage";
  static const String locUnAuthorizedError = "unauthorized_error";
  static const String locUnAuthorizedErrorMessage =
      "unauthorized_error_message";
  //network errors
  static const String locNetworkError = "locNetworkError";
  static const String locServerError = "server_error";
  static const String locServerErrorMessage = "server_error_message";
  static const String locSessionErrorMessage = "session_error_message";
  static const String locNoInternetConnection = "no_internet_connection";
  static const String locNetworkErrorTitle = "network_error_title";
  static const String locNetworkErrorDescription = "network_error_description";
  static const String locNetworkErrorMessage = "locNetworkErrorMessage";
  }

enum NoRoute { title, body }
