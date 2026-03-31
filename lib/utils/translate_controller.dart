import 'package:bnpteam/utils/exported_path.dart';
import 'package:translator/translator.dart';

@lazySingleton
class TranslateController extends GetxController {
  final GoogleTranslator _translator = GoogleTranslator();
  final lang = 'mr'.obs;

  Future<String> translate(String text, String targetLanguage) async {
    final result = await _translator.translate(text, to: targetLanguage);
    return result.text;
  }

  void toggleLang() {
    lang.value = lang.value == 'en' ? 'mr' : 'en';
    // print('Language changed to: ${lang.value}');
  }
}
