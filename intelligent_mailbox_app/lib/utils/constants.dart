class Constants {
  static const String connectionChecking = 'CHECKING';
  static const String connectionFailed = 'FAILED';
  static const String connectionSuccess = 'SUCCESS';

  static const int doorClosed = 0;
  static const int doorOpened = 1;


  static const String languageSpanish= 'es';
  static const String languageEnglish = 'en';
  static const String languageDefault = languageEnglish;
  static const List<String> supportedLanguages = [
    languageSpanish,
    languageEnglish,
  ];
}
