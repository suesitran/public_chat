import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryInitial());

  String currentCountryCodeSelected = '';
  String tempCountryCodeSelected = '';

  void setCountrySelectedInitialIfAny(String countryCode) {
    currentCountryCodeSelected = Constants.countries.indexWhere(
                (el) => el['country_code'] == countryCode.toUpperCase()) !=
            -1
        ? countryCode
        : Constants.countryCodeDefault;
    emit(CurrentCountryCodeSelected(countryCode: currentCountryCodeSelected));
  }

  Future<void> selectCountry(String countryCode) async {
    tempCountryCodeSelected = Constants.countries.indexWhere(
                (el) => el['country_code'] == countryCode.toUpperCase()) !=
            -1
        ? countryCode
        : Constants.countryCodeDefault;
    emit(TemporaryCountryCodeSelected(countryCode: tempCountryCodeSelected));
  }

  Future<void> agreementConfirmSelectCountry() async {
    currentCountryCodeSelected = tempCountryCodeSelected;
    tempCountryCodeSelected = '';
    await ServiceLocator.instance.get<SharedPreferences>().setString(
          Constants.prefCurrentCountryCode,
          currentCountryCodeSelected,
        );
    emit(TemporaryCountryCodeSelected(countryCode: tempCountryCodeSelected));
    emit(CurrentCountryCodeSelected(countryCode: currentCountryCodeSelected));
  }

  String getCountryNameSelected() {
    return Constants.countries.firstWhere(
        (el) => el['country_code'] == tempCountryCodeSelected)['name'];
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
