import 'package:equatable/equatable.dart';

class LanguageSupport extends Equatable {
  final String? code;
  final String? englishName;
  final String? flag;
  final String? nativeName;

  const LanguageSupport(
      {this.code, this.englishName, this.flag, this.nativeName});

  LanguageSupport.fromMap(Map<String, dynamic> map)
      : code = map['code'],
        englishName = map['englishName'],
        flag = map['flag'],
        nativeName = map['nativeName'];

  Map<String, dynamic> toMap() => {
        'code': code,
        'englishName': englishName,
        'flag': flag,
        'nativeName': nativeName
      };

  @override
  List<Object?> get props => [code];
}
