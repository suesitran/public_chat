import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:public_chat/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryInitial());

  String currentCountryCodeSelected = '';
  String tempCountryCodeSelected = '';
  String currentLanguageCodeSelected = '';
  String previousLanguageCodeSelected = '';

  void setCountrySelectedInitial(String countryCode) {
    currentCountryCodeSelected = countryCode;
    currentLanguageCodeSelected =
        Helper.getLanguageCodeByCountryCode(countryCode);
    emit(CurrentCountryCodeSelected(countryCode: currentCountryCodeSelected));
  }

  Future<void> selectCountry(String countryCode) async {
    tempCountryCodeSelected = countryCode;
    emit(TemporaryCountryCodeSelected(countryCode: tempCountryCodeSelected));
  }

  Future<void> agreementConfirmSelectCountry() async {
    currentCountryCodeSelected = tempCountryCodeSelected;
    tempCountryCodeSelected = '';
    previousLanguageCodeSelected = currentLanguageCodeSelected;
    currentLanguageCodeSelected =
        Helper.getLanguageCodeByCountryCode(currentCountryCodeSelected);
    await ServiceLocator.instance.get<SharedPreferences>().setString(
          Constants.prefCurrentCountryCode,
          currentCountryCodeSelected,
        );
    emit(TemporaryCountryCodeSelected(countryCode: tempCountryCodeSelected));
    emit(CurrentCountryCodeSelected(countryCode: currentCountryCodeSelected));
  }

  String getCountryNameSelected() {
    final indexCountryCodeSelectedInList = Constants.countries
        .indexWhere((el) => el['country_code'] == tempCountryCodeSelected);
    return indexCountryCodeSelectedInList != -1
        ? Constants.countries[indexCountryCodeSelectedInList]['name']
        : '';
  }

  bool checkAllowShowButtonAction(bool isHasBackButton) {
    if (isHasBackButton) {
      return tempCountryCodeSelected.isNotEmpty &&
          currentCountryCodeSelected != tempCountryCodeSelected;
    }
    return true;
  }

  bool checkNeedConfirmSelectCountry() {
    return currentCountryCodeSelected.isEmpty ||
        (tempCountryCodeSelected.isNotEmpty &&
            currentCountryCodeSelected != tempCountryCodeSelected);
  }

  void resetValueTempCountryCodeSelected() {
    tempCountryCodeSelected = '';
  }
}
