part of 'locale_bloc.dart';

abstract class LocaleState {
  final Locale locale;

  const LocaleState(this.locale);
}

class LocaleInitial extends LocaleState {
  const LocaleInitial(super.locale);
}

class LocaleChanged extends LocaleState {
  const LocaleChanged(super.locale);
}
