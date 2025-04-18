import 'package:equatable/equatable.dart';

class TranslateState extends Equatable {
  final String codeCountry;
  final String translatedText;

  const TranslateState({
    required this.codeCountry,
    required this.translatedText,
  });

  factory TranslateState.initial() {
    return const TranslateState(
      codeCountry: 'en',
      translatedText: '',
    );
  }

  TranslateState copyWith({
    String? codeCountry,
    String? translatedText,
  }) {
    return TranslateState(
      codeCountry: codeCountry ?? this.codeCountry,
      translatedText: translatedText ?? this.translatedText,
    );
  }

  @override
  List<Object?> get props => [codeCountry, translatedText];
}
