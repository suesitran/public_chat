import 'package:equatable/equatable.dart';

final class Country extends Equatable {
  final String name;
  final String code;

  const Country({required this.name, required this.code});

  factory Country.fromMap(Map json) => Country(
        code: json['name'],
        name: json['code'],
      );

  factory Country.fromRestCountries(Map json) => Country(
        code: json['cca2'],
        name: json['name']['common'],
      );

  Map<String, dynamic> toMap() => {'name': name, 'code': code};

  @override
  List<Object?> get props => [name, code];
}
