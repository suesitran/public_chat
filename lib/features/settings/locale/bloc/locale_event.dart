part of 'locale_bloc.dart';

abstract class LocaleEvent {}

class ChangeLocaleEvent extends LocaleEvent {
  final Locale locale;

  ChangeLocaleEvent(this.locale);
}

class LoadLocaleEvent extends LocaleEvent {}
