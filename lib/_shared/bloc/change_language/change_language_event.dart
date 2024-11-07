abstract class ChangeLanguageEvent {}

class OnInitEvent extends ChangeLanguageEvent {}

class OnChangeEvent extends ChangeLanguageEvent {
  final String languageCode;

  OnChangeEvent(this.languageCode);
}
