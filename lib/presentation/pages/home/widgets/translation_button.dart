import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TranslationButton extends StatelessWidget {
  final String initialLanguage;
  final Function(String) onLanguageChanged;

  const TranslationButton({
    super.key,
    required this.initialLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
       final languages = {
      'en': 'English',
      'es': 'Español', // Испанский
      'zh': '中文', // Китайский
      'tl': 'Tagalog', // Тагальский
      'vi': 'Tiếng Việt', // Вьетнамский
      'ar': 'العربية', // Арабский
      'fr': 'Français', // Французский
      'ko': '한국어', // Корейский
      'de': 'Deutsch', // Немецкий
      'pt': 'Português', // Португальский
      'hi': 'हिन्दी', // Хинди
      'ur': 'اردو', // Урду
      'ru': 'Русский', 
      'uk': 'Українська'
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        customButton: const Icon(Icons.translate, size: 24),
        items: languages.entries.map((entry) => DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        )).toList(),
        value: initialLanguage.isNotEmpty ? initialLanguage : 'en',
        onChanged: (String? value) {
          if (value != null) {
            onLanguageChanged(value);
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
          elevation: 8,
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

