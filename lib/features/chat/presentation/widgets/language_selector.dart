import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: SizedBox(
        width: double.maxFinite,
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: AppConstants.supportedLanguages.length,
              itemBuilder: (context, index) {
                final languageCode = AppConstants.supportedLanguages[index];
                final languageName = AppConstants.languageNames[languageCode] ?? languageCode;
                final isSelected = chatProvider.selectedLanguage == languageCode;
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                    child: Text(
                      languageCode.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    languageName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryColor : null,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryColor) : null,
                  onTap: () {
                    chatProvider.setLanguage(languageCode);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $languageName'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}