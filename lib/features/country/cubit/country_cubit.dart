import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryInitial());

  String currentCountryCodeSelected = '';

  Future<void> selectCountry(String countryCode, {bool? isAgreement}) async {
    currentCountryCodeSelected = Constants.countries.indexWhere(
                (el) => el['country_code'] == countryCode.toUpperCase()) !=
            -1
        ? countryCode
        : Constants.countryCodeDefault;
    if (isAgreement ?? false) {
      await ServiceLocator.instance.get<SharedPreferences>().setString(
            Constants.prefCurrentCountryCode,
            currentCountryCodeSelected,
          );
      emit(CurrentCountryCodeSelected(countryCode: currentCountryCodeSelected));
    } else {
      emit(TemporaryCountryCodeSelected(
          countryCode: currentCountryCodeSelected));
    }
  }

  String getCountryNameSelected() {
    return Constants.countries.firstWhere(
        (el) => el['country_code'] == currentCountryCodeSelected)['name'];
  }
}
