import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/language.dart';
import 'package:public_chat/network/services/language_services.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'language_manage_event.dart';
part 'language_manage_state.dart';

final class LanguageManageBloc
    extends Bloc<LanguageManageEvent, LanguageManageState> {
  //cache language
  static List<Language>? _languages;

  final searchTextController = TextEditingController();
  Timer? queryTimer;

  LanguageManageBloc() : super(const LanguageManageState()) {
    on<LanguageManageInit>(_onInit);
    on<LanguageManageSearchTextChanged>(_onSearchTextChanged);
    on<LanguageManageSearch>(_onSearch);
    on<LanguageManageClearSearchText>(_onClearSearchText);
  }

  @override
  Future<void> close() {
    queryTimer?.cancel();

    return super.close();
  }

  void _onInit(
      LanguageManageInit event, Emitter<LanguageManageState> emit) async {
    emitSafely(state.copyWith(
        appLanguage: event.appLanguage,
        messageLanguage: event.messageLanguage,
        appLanguages: event.supportedLocales
            .map((e) => Language.fromMapping(code: e.languageCode))
            .toList()));

    if (!event.isFetchMessageLanguage) return;

    // fetch languages for chat
    try {
      if (_languages == null) {
        var languages = await LanguageServices.fetchLanguages();

        if (event.supportedLocales.isNotEmpty) {
          final prioritizedLanguages = <Language>[];
          final nonPrioritizedLanguages = <Language>[];

          for (final language in languages) {
            event.supportedLocales.indexWhere(
                        (element) => language.code == element.languageCode) !=
                    -1
                ? prioritizedLanguages.add(language)
                : nonPrioritizedLanguages.add(language);
          }

          languages = [...prioritizedLanguages, ...nonPrioritizedLanguages];
        }

        _languages = languages;
      }

      emitSafely(state.copyWith(
          status: LanguageFetchStatus.success,
          messageLanguages: _languages,
          languagesFiltered: _languages,
          errorMessage: ''));
    } catch (e) {
      emitSafely(state.copyWith(
          status: LanguageFetchStatus.failed, errorMessage: e.toString()));
    }
  }

  void _onSearchTextChanged(LanguageManageSearchTextChanged event,
      Emitter<LanguageManageState> emit) {
    emitSafely(
        state.copyWith(searchText: event.searchText.trim().toLowerCase()));

    queryTimer?.cancel();
    queryTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        add(LanguageManageSearch());
      },
    );
  }

  void _onClearSearchText(
      LanguageManageClearSearchText event, Emitter<LanguageManageState> emit) {
    queryTimer?.cancel();
    searchTextController.clear();
    emitSafely(state.copyWith(
        languagesFiltered: state.messageLanguages, searchText: ''));
  }

  void _onSearch(
      LanguageManageSearch event, Emitter<LanguageManageState> emit) {
    bool isContainText(List<String?> keys, String query) {
      var isContain = false;

      for (final key in keys) {
        if (key != null) isContain = key.toLowerCase().contains(query);
        if (isContain) break;
      }

      return isContain;
    }

    final languageFiltered = <Language>[];

    for (final language in state.messageLanguages) {
      if (isContainText([
        language.name,
        language.navigateName,
        language.code,
        ...language.countries.map((e) => e.name)
      ], state.searchText)) {
        languageFiltered.add(language);
      }
    }

    emitSafely(state.copyWith(languagesFiltered: languageFiltered));
  }
}
