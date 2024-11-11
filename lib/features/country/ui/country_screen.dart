import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/cubit/country_cubit.dart';
import 'package:public_chat/utils/app_extensions.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:country_flags/country_flags.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final countryCode =
          WidgetsBinding.instance.platformDispatcher.locale.countryCode;
      if (!(widget.isHasBackButton ?? false) &&
          countryCode.isNotNullAndNotEmpty) {
        context.read<CountryCubit>().selectCountry(countryCode!);
      }
    });
    super.initState();
  }

  Future<void> _scrollToCountrySelected(String countryCodeSelected) async {
    int indexCountrySelected = Constants.countries
        .indexWhere((el) => el['country_code'] == countryCodeSelected);
    await _scrollController.animateTo(
      indexCountrySelected * 32,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Languages'),
        actions: widget.isHasBackButton ?? false
            ? [
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PublicChatScreen()),
                  ),
                  child: const Text(
                    'Go',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<CountryCubit, CountryState>(
          listenWhen: (previous, current) =>
              current is CurrentCountryCodeSelected,
          listener: (context, state) async =>
              state is CurrentCountryCodeSelected
                  ? await _scrollToCountrySelected(state.countryCode)
                  : null,
          buildWhen: (previous, current) =>
              current is CurrentCountryCodeSelected,
          builder: (context, state) {
            final countryCodeSelected =
                state is CurrentCountryCodeSelected ? state.countryCode : '';
            return ListView.builder(
              controller: _scrollController,
              itemCount: Constants.countries.length,
              itemBuilder: (_, index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 2,
                      color: Constants.countries[index]['country_code'] ==
                              countryCodeSelected
                          ? Colors.brown
                          : Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      CountryFlag.fromCountryCode(
                        Constants.countries[index]['country_code'],
                        shape: const Circle(),
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          Constants.countries[index]['name'],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
