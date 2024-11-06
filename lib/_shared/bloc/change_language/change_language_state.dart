import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChangeLanguageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmptyState extends ChangeLanguageState {}

class InitState extends ChangeLanguageState {
  final Locale locale;

  InitState(this.locale);

  @override
  List<Object?> get props => [locale];
}

class ChangeState extends ChangeLanguageState {
  final Locale locale;

  ChangeState(this.locale);

  @override
  List<Object?> get props => [locale];
}
