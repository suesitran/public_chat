import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryInitial());

  Future<void> selectCountry(String countryCode) async {
    final code = Constants.countries.indexWhere(
                (el) => el['country_code'] == countryCode.toUpperCase()) !=
            -1
        ? countryCode
        : Constants.countryCodeDefault;
    await ServiceLocator.instance
        .get<SharedPreferences>()
        .setString(Constants.prefCurrentCountryCode, code);
    emit(CurrentCountryCodeSelected(countryCode: code));
  }
}
