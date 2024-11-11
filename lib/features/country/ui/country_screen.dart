import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/features/country/cubit/country_cubit.dart';
import 'package:public_chat/utils/app_extensions.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key, this.isHasBackButton});

  final bool? isHasBackButton;

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isHasBackButton ?? false) {
        await _scrollToCountrySelected(
          context.read<ChatCubit>().currentCountryCodeSelected,
        );
      } else {
        await _showNoticeDialogSelectCountry();
        final countryCode =
            WidgetsBinding.instance.platformDispatcher.locale.countryCode;
        if (!(widget.isHasBackButton ?? false) &&
            countryCode.isNotNullAndNotEmpty &&
            mounted) {
          context
              .read<CountryCubit>()
              .selectCountry(countryCode!, isAgreement: true);
          await _scrollToCountrySelected(countryCode);
        }
      }
    });
    super.initState();
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
          'Are you sure you want to use ${context.read<CountryCubit>().getCountryNameSelected()} language?',
      titleButtonClose: 'Close',
      titleButtonSubmit: 'OK',
      callBackClickSubmit: () => Navigator.of(context).pop(),
    );
  }

  Future<void> _scrollToCountrySelected(String countryCodeSelected) async {
    int indexCountrySelected = Constants.countries
        .indexWhere((el) => el['country_code'] == countryCodeSelected);
    await Future.delayed(const Duration(milliseconds: 300));
    await _scrollController.animateTo(
      indexCountrySelected * 56,
      duration: const Duration(milliseconds: 800),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: (widget.isHasBackButton ?? false)
            ? GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 24,
                ),
              )
            : null,
        title: const Text('Countries'),
        actions: widget.isHasBackButton ?? false
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    // onTap: () => Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const PublicChatScreen(),
                    //   ),
                    // ),
                    onTap: () async => await _showConfirmDialogSelectCountry(),
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: BlocBuilder<CountryCubit, CountryState>(
            buildWhen: (previous, current) =>
                current is CurrentCountryCodeSelected,
            builder: (context, state) {
              final countryCodeSelected =
                  state is CurrentCountryCodeSelected ? state.countryCode : '';
              return ListView.builder(
                controller: _scrollController,
                itemCount: Constants.countries.length,
                itemBuilder: (_, index) {
                  final countryCode =
                      Constants.countries[index]['country_code'];
                  final countryName = Constants.countries[index]['name'];
                  final isSelected = countryCode == countryCodeSelected;
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
                                color:
                                    isSelected ? Colors.black : Colors.black54,
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
