import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/cubit/country_cubit.dart';
import 'package:public_chat/features/language_load/language_load.dart';
import 'package:public_chat/utils/app_extensions.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';
import 'package:public_chat/utils/helper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({
    super.key,
    this.isHasBackButton,
    required this.currentCountryCode,
    required this.currentLanguageCode,
  });

  final bool? isHasBackButton;
  final String currentCountryCode;
  final String currentLanguageCode;

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final _scrollController = ItemScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!(widget.isHasBackButton ?? false)) {
        await _showNoticeDialogSelectCountry();
      }
      await _setCurrentCountryCode();
    });
    super.initState();
  }

  Future<void> _setCurrentCountryCode() async {
    final currentCountryCode = widget.currentCountryCode;
    context.read<CountryCubit>().setCountrySelectedInitial(currentCountryCode);
    await _scrollToCountrySelected(currentCountryCode);
  }

  String _getCurrentLanguageCode(CountryCubit countryCubit) {
    return countryCubit.currentLanguageCodeSelected.isNotEmpty
        ? countryCubit.currentLanguageCodeSelected
        : widget.currentLanguageCode;
  }

  Future<void> _showNoticeDialogSelectCountry() async {
    final countryCubit = context.read<CountryCubit>();
    await FunctionsAlertDialog.showNoticeAndConfirmDialog(
      context,
      title: Helper.getTextTranslated(
        'notificationTitle',
        _getCurrentLanguageCode(countryCubit),
        previousLanguageCode: countryCubit.previousLanguageCodeSelected,
      ),
      description: Helper.getTextTranslated(
        'noticeSelectCountryText',
        _getCurrentLanguageCode(countryCubit),
        previousLanguageCode: countryCubit.previousLanguageCodeSelected,
      ),
      titleButtonClose: Helper.getTextTranslated(
        'buttonCloseTitle',
        _getCurrentLanguageCode(countryCubit),
        previousLanguageCode: countryCubit.previousLanguageCodeSelected,
      ),
    );
  }

  Future<void> _showConfirmDialogSelectCountry() async {
    final countryCubit = context.read<CountryCubit>();
    final countryNameSelected =
        context.read<CountryCubit>().getCountryNameSelected();
    if (countryNameSelected.isNotEmpty) {
      await FunctionsAlertDialog.showNoticeAndConfirmDialog(
        context,
        title: Helper.getTextTranslated(
          'confirmTitle',
          _getCurrentLanguageCode(countryCubit),
          previousLanguageCode: countryCubit.previousLanguageCodeSelected,
        ),
        description: '${Helper.getTextTranslated(
          'confirmSelectCountryText',
          _getCurrentLanguageCode(countryCubit),
          previousLanguageCode: countryCubit.previousLanguageCodeSelected,
        )}\n"$countryNameSelected"?',
        titleButtonClose: Helper.getTextTranslated(
          'buttonCloseTitle',
          _getCurrentLanguageCode(countryCubit),
          previousLanguageCode: countryCubit.previousLanguageCodeSelected,
        ),
        titleButtonSubmit: Helper.getTextTranslated(
          'buttonOKTitle',
          _getCurrentLanguageCode(countryCubit),
          previousLanguageCode: countryCubit.previousLanguageCodeSelected,
        ),
        callBackClickSubmit: () {
          context.read<CountryCubit>().agreementConfirmSelectCountry();
          Navigator.of(context).pop();
        },
      );
    }
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
        leading: _buildLeadingButtonBack(countryCubit),
        centerTitle: true,
        title: _buildTitleAppBar(countryCubit),
        actions: [_buildButtonActionAppBar(countryCubit)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: _buildListCountry(countryCubit),
        ),
      ),
    );
  }

  Widget? _buildLeadingButtonBack(CountryCubit countryCubit) {
    return (widget.isHasBackButton ?? false)
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
        : null;
  }

  Widget _buildTitleAppBar(CountryCubit countryCubit) {
    return BlocConsumer<CountryCubit, CountryState>(
      listenWhen: (previous, current) => current is CurrentCountryCodeSelected,
      listener: (context, state) => state is CurrentCountryCodeSelected
          ? context
              .read<LanguageLoadCubit>()
              .loadAllLanguageStatic(state.countryCode)
          : null,
      buildWhen: (previous, current) => current is CurrentCountryCodeSelected,
      builder: (context, state) {
        return BlocConsumer<LanguageLoadCubit, LanguageLoadState>(
          listenWhen: (previous, current) =>
              current is LanguageLoadSuccess ||
              current is LanguageLoadInProgress,
          listener: (context, state) async {
            if (state is LanguageLoadInProgress) {
              await FunctionsAlertDialog.showLoadingDialog(context);
            } else {
              Navigator.of(context).pop();
            }
          },
          buildWhen: (previous, current) => current is LanguageLoadSuccess,
          builder: (context, state) {
            return Text(
              Helper.getTextTranslated(
                'countryScreenTitle',
                _getCurrentLanguageCode(countryCubit),
                previousLanguageCode: countryCubit.previousLanguageCodeSelected,
              ),
              style: const TextStyle(color: Colors.black, fontSize: 24),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonActionAppBar(CountryCubit countryCubit) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: BlocBuilder<CountryCubit, CountryState>(
          buildWhen: (previous, current) =>
              current is CurrentCountryCodeSelected ||
              current is TemporaryCountryCodeSelected,
          builder: (context, state) {
            final isShowButtonAction = countryCubit
                .checkAllowShowButtonAction(widget.isHasBackButton ?? false);
            final currentCountryCode = state is TemporaryCountryCodeSelected &&
                    state.countryCode.isNotNullAndNotEmpty
                ? state.countryCode
                : countryCubit.currentCountryCodeSelected;
            return isShowButtonAction
                ? GestureDetector(
                    onTap: () async =>
                        countryCubit.checkNeedConfirmSelectCountry()
                            ? await _showConfirmDialogSelectCountry()
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    currentCountryCode: currentCountryCode,
                                    currentLanguageCode: countryCubit
                                        .currentLanguageCodeSelected,
                                  ),
                                ),
                              ),
                    child: BlocBuilder<LanguageLoadCubit, LanguageLoadState>(
                      buildWhen: (previous, current) =>
                          current is LanguageLoadSuccess,
                      builder: (context, state) {
                        return Text(
                          countryCubit.checkNeedConfirmSelectCountry()
                              ? Helper.getTextTranslated(
                                  'buttonSelectTitle',
                                  _getCurrentLanguageCode(countryCubit),
                                  previousLanguageCode:
                                      countryCubit.previousLanguageCodeSelected,
                                )
                              : Helper.getTextTranslated(
                                  'buttonGoTitle',
                                  _getCurrentLanguageCode(countryCubit),
                                  previousLanguageCode:
                                      countryCubit.previousLanguageCodeSelected,
                                ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildListCountry(CountryCubit countryCubit) {
    return BlocBuilder<CountryCubit, CountryState>(
      buildWhen: (previous, current) =>
          current is CurrentCountryCodeSelected ||
          current is TemporaryCountryCodeSelected,
      builder: (context, state) {
        final countryCodeSelected = countryCubit.currentCountryCodeSelected;
        final tempCountryCodeSelected = countryCubit.tempCountryCodeSelected;
        return ScrollablePositionedList.builder(
          itemScrollController: _scrollController,
          itemCount: Constants.countries.length - 1,
          itemBuilder: (_, index) {
            final countryCode = Constants.countries[index]['country_code'];
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
    );
  }
}
