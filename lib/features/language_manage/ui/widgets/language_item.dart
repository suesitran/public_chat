import 'package:flutter/material.dart';
import 'package:public_chat/_shared/data/language.dart';

class LanguageItem extends StatelessWidget {
  final bool isSelected;
  final int index;
  final Language language;
  final void Function(Language language) onTap;

  const LanguageItem({
    super.key,
    required this.isSelected,
    required this.index,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.blue
              : index.isEven
                  ? null
                  : Colors.blue.withOpacity(0.1),
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: () {
        Navigator.maybePop(context);
        onTap(language);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            language.flagUrl,
            height: 18,
            width: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 18,
              width: 28,
              color: Colors.blue.shade200,
              alignment: Alignment.center,
              child: const Icon(
                Icons.info,
                size: 15,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              language.navigateName ?? language.name,
              style: TextStyle(color: isSelected ? Colors.white : null),
            ),
          ),
          if (isSelected) const Icon(Icons.check, color: Colors.white),
        ],
      ),
    );
  }
}
