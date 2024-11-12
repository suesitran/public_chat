import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/cubit/country_cubit.dart';
import 'package:public_chat/utils/app_extensions.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key, this.isHasBackButton});

  final bool? isHasBackButton;

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final _scrollController = ItemScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.isHasBackButton ?? false
          ? await _handleInCaseHadCountryCodeSelected()
          : await _handleInCaseNotYetCountryCodeSelected();
    });
    super.initState();
  }

  Future<void> _handleInCaseHadCountryCodeSelected() async {
    final countryCode = context.read<ChatCubit>().currentCountryCodeSelected;
    context.read<CountryCubit>().setCountrySelectedInitialIfAny(countryCode);
    await _scrollToCountrySelected(countryCode);
  }

  Future<void> _handleInCaseNotYetCountryCodeSelected() async {
    await _showNoticeDialogSelectCountry();
    final countryCode =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    if (!(widget.isHasBackButton ?? false) &&
        countryCode.isNotNullAndNotEmpty &&
        mounted) {
      context.read<CountryCubit>().selectCountry(countryCode!);
      await _scrollToCountrySelected(countryCode);
    }
  }

  Future<void> _showNoticeDialogSelectCountry() async {
    await FunctionsAlertDialog.showNoticeAndConfirmDialog(
      context,
      title: 'Notification',
      description: 'Select country or use country default to use app',
      titleButtonClose: 'Close',
    );
  }

  Future<void> _showConfirmDialogSelectCountry() async {
    await FunctionsAlertDialog.showNoticeAndConfirmDialog(
      context,
      title: 'Confirm',
      description:
          'Are you sure you want to use\n"${context.read<CountryCubit>().getCountryNameSelected()}" language?',
      titleButtonClose: 'Close',
      titleButtonSubmit: 'OK',
      callBackClickSubmit: () {
        context.read<CountryCubit>().agreementConfirmSelectCountry();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _scrollToCountrySelected(String countryCodeSelected) async {
    int indexCountrySelected = Constants.countries
        .indexWhere((el) => el['country_code'] == countryCodeSelected);
    await Future.delayed(const Duration(milliseconds: 300));
    _scrollController.scrollTo(
      index: indexCountrySelected,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryCubit = context.read<CountryCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: (widget.isHasBackButton ?? false)
            ? GestureDetector(
                onTap: () {
                  countryCubit.resetValueTempCountryCodeSelected();
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 24,
                ),
              )
            : null,
        title: const Text(
          'Countries',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: BlocBuilder<CountryCubit, CountryState>(
                buildWhen: (previous, current) =>
                    current is CurrentCountryCodeSelected ||
                    current is TemporaryCountryCodeSelected,
                builder: (context, state) {
                  final isShowButtonAction =
                      countryCubit.checkAllowShowButtonAction(
                          widget.isHasBackButton ?? false);
                  return isShowButtonAction
                      ? GestureDetector(
                          onTap: () async =>
                              countryCubit.checkNeedConfirmSelectCountry()
                                  ? await _showConfirmDialogSelectCountry()
                                  : Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PublicChatScreen(),
                                      ),
                                    ),
                          child: Text(
                            countryCubit.checkNeedConfirmSelectCountry()
                                ? 'Select'
                                : 'Go',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: BlocBuilder<CountryCubit, CountryState>(
            buildWhen: (previous, current) =>
                current is CurrentCountryCodeSelected ||
                current is TemporaryCountryCodeSelected,
            builder: (context, state) {
              final countryCodeSelected =
                  countryCubit.currentCountryCodeSelected;
              final tempCountryCodeSelected =
                  countryCubit.tempCountryCodeSelected;
              return ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemCount: Constants.countries.length - 1,
                itemBuilder: (_, index) {
                  final countryCode =
                      Constants.countries[index]['country_code'];
                  final countryName = Constants.countries[index]['name'];
                  final isSelected = countryCode == countryCodeSelected;
                  final isSelectedTemp = countryCode == tempCountryCodeSelected;
                  return GestureDetector(
                    onTap: () => context.read<CountryCubit>().selectCountry(
                          countryCode,
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: isSelected
                              ? Colors.green
                              : isSelectedTemp
                                  ? Colors.brown
                                  : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CountryFlag.fromCountryCode(
                            countryCode,
                            shape: const Circle(),
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              countryName,
                              style: TextStyle(
                                color: isSelected || isSelectedTemp
                                    ? Colors.black
                                    : Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              size: 24,
                              color: Colors.green,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
