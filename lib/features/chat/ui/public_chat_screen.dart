import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/message_box_widget.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';
import 'package:public_chat/utils/app_extensions.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';
import 'package:public_chat/utils/locale_support.dart';

class PublicChatScreen extends StatefulWidget {
  const PublicChatScreen({super.key});

  @override
  State<PublicChatScreen> createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().getCurrentLanguageCodeSelected();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
    final User? user = FirebaseAuth.instance.currentUser;

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is LogoutLoading ||
          current is LogoutSuccess ||
          current is LogoutFailed,
      listener: (context, state) async {
        if (state is LogoutLoading) {
          await FunctionsAlertDialog.showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        if (state is LogoutSuccess && context.mounted) {
          FunctionsAlertDialog.showAlertFlushBar(
            context,
            'Logout successfully',
            true,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
        if (state is LogoutFailed && context.mounted) {
          FunctionsAlertDialog.showAlertFlushBar(
            context,
            'Logout failed. Try again',
            false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: BlocConsumer<CountryCubit, CountryState>(
            listenWhen: (previous, current) =>
                current is CurrentCountryCodeSelected,
            listener: (context, state) =>
                chatCubit.getCurrentLanguageCodeSelected(),
            buildWhen: (previous, current) =>
                current is CurrentCountryCodeSelected,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: CountryFlag.fromCountryCode(
                  state is CurrentCountryCodeSelected &&
                          state.countryCode.isNotNullAndNotEmpty
                      ? state.countryCode
                      : chatCubit.currentCountryCodeSelected,
                  shape: const Circle(),
                ),
              );
            },
          ),
          title: Text(
            context.locale.publicRoomTitle,
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  isDense: true,
                  value: 0,
                  customButton: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 32,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    offset: const Offset((160 - 24) * -1, -6),
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 46),
                  items: [0, 1].map<DropdownMenuItem<int>>((int option) {
                    return DropdownMenuItem<int>(
                      value: option,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (option == 0) const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                option == 0 ? Icons.language : Icons.logout,
                                color: Colors.black,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                option == 0 ? 'Language' : 'Logout',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          if (option == 0) ...[
                            const Spacer(),
                            const Divider(height: 0.3, color: Colors.grey)
                          ]
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CountryScreen(
                            isHasBackButton: true,
                          ),
                        ),
                      );
                    } else {
                      context.read<LoginCubit>().requestLogout();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    return FirestoreListView<Message>(
                      query: chatCubit.chatContent,
                      reverse: true,
                      itemBuilder: (BuildContext context,
                          QueryDocumentSnapshot<Message> doc) {
                        if (!doc.exists) {
                          return const SizedBox.shrink();
                        }

                        final Message message = doc.data();

                        return BlocProvider<UserManagerCubit>.value(
                          value: UserManagerCubit()
                            ..queryUserDetail(message.sender),
                          child:
                              BlocBuilder<UserManagerCubit, UserManagerState>(
                            builder: (context, state) {
                              String? photoUrl;
                              String? displayName;

                              if (state is UserDetailState) {
                                photoUrl = state.photoUrl;
                                displayName = state.displayName;
                              }

                              return ChatBubble(
                                isMine: message.sender == user?.uid,
                                message:
                                    chatCubit.getMessageTranslated(message),
                                photoUrl: photoUrl,
                                displayName: displayName,
                                translations: message.translations,
                              );
                            },
                          ),
                        );
                      },
                      emptyBuilder: (context) => const Center(
                        child: Text(
                            'No messages found. Send the first message now!'),
                      ),
                      loadingBuilder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
              MessageBox(
                onSendMessage: (value) {
                  if (user == null) {
                    // do nothing
                    return;
                  }
                  chatCubit.sendChat(uid: user.uid, message: value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
