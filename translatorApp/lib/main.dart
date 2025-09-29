import 'package:flutter/material.dart';
// import 'package:translator/translator.dart';
// import 'package:google_translator/google_translator.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:simple_translator/simple_translator.dart';

void main() {
  runApp(const MyApp());
}

// class GoogleTransService {
//   final String apiKEY = 'APIKEY';

//   Future<List<Map<String, String>>> supportedLangs({
//     String target = "en",
//   }) async {
//     try {
//       final url = Uri.parse(
//         'https://translation.googleapis.com/language/v2/languages?target=$target&key=$apiKEY',
//       );

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List langs = data['data']['languages'];
//         return langs.map<Map<String, String>>((lang) {
//           return {
//             'code': lang['language'],
//             'name': lang['name'] ?? lang['language'],
//           };
//         }).toList();
//       } else {
//         print('Failed to fetch languages. Status code: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching languages: $e');
//       return [];
//     }
//   }
// }

// Instance of the translator from simple_translator package
final translator = GoogleTranslator();

// Function to translate text using the translator instance
Future<String> translateText(
  String inputText,
  String fromLang,
  String toLang,
) async {
  try {
    final translation = await translator.translate(
      inputText,
      from: fromLang,
      to: toLang,
    );
    return translation.text;
  } catch (e) {
    print("Translation failed: $e");
    return "Error"; // fallback so the function always returns a String
  }
}

// Notifiers for selected input and output languages and rebuilds when value changes
ValueNotifier<String> inputNotifier = ValueNotifier<String>('English');
ValueNotifier<String> outputNotifier = ValueNotifier<String>('Bengali');

// Rotatation for swaping languages button
double turns = 0.0;
// final List<String> languages = [
//   'English',
//   'Spanish',
//   'French',
//   'German',
//   'Chinese',
// ];

// Supported languages with ISO codes
final Map<String, String> languages = {
  'English': 'en',
  'Bengali': 'bn',
  'Spanish': 'es',
  'Korean': 'ko',
  "Portuguese": "pt",
  "Hindi": "hi",
  "Japanese": "ja",
  "Dutch": "nl",
  "Arabic": "ar",
};

// Method to extract the code from the language name
String langCode(String lang) {
  return languages[lang] ?? 'en';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translator App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LanguageScreenSelect(),
    );
  }
}

// Statefull widget fro home screen where user selects language
class LanguageScreenSelect extends StatefulWidget {
  const LanguageScreenSelect({super.key});

  @override
  State<LanguageScreenSelect> createState() => _LanguageScreenSelectState();
}

class _LanguageScreenSelectState extends State<LanguageScreenSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              inputTransLang(), // Button to select input language
              const SizedBox(height: 20),
              SwapLangBut(), // Button to swap output and input languages
              const SizedBox(height: 20),
              outputTransLang(), // Button to select output language
              TranslateDescription(), // Text showing "Translate from X to Y" dynamically
              const SizedBox(height: 40),
              NavToTrans(context), // Button to navigate to translation form
            ],
          ),
        ),
      ),
    );
  }

  Padding NavToTrans(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          minimumSize: const Size(80, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LanguageTranslation(),
            ),
          );
        },

        // child: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     const Text(
        //       'Translate',
        //       style: TextStyle(
        //         fontSize: 18,
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     SizedBox(width: 10),
        //     Icon(Icons.arrow_forward, color: Colors.white),
        //   ],
        // ),
        child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
      ),
    );
  }

  Padding TranslateDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 80, right: 80),
      child: ValueListenableBuilder<String>(
        valueListenable: inputNotifier,
        builder: (context, inputValue, child) {
          return ValueListenableBuilder(
            valueListenable: outputNotifier,
            builder: (context, outputValue, child) {
              return Text(
                "Translate from $inputValue to $outputValue".toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Container SwapLangBut() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Transform.rotate(
        angle: 90 * 3.1415926535 / 180, // static 90° rotation
        child: AnimatedRotation(
          turns: turns,
          duration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            onPressed: () {
              setState(() {
                turns += 0.5; // 0.5 turns = 180°
                final temp = inputNotifier.value;
                inputNotifier.value = outputNotifier.value;
                outputNotifier.value = temp;
              });
              // print("Button Pressed");
            },
          ),
        ),
      ),
    );
  }

  Container inputTransLang() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 350,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      height: 100,
      child: ValueListenableBuilder<String>(
        valueListenable: inputNotifier,
        builder: (context, value, _) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.only(left: 18.0),
              isExpanded: true,
              items: languages.keys.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Center(
                    child: Text(
                      language,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newvalue) {
                if (newvalue != null) {
                  inputNotifier.value = newvalue; // update the notifier
                }
              },
            ),
          );
        },
      ),
    );
  }

  Container outputTransLang() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 350,
      decoration: BoxDecoration(
        color: Colors.black,
        // border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      height: 100,
      child: ValueListenableBuilder<String>(
        valueListenable: outputNotifier,
        builder: (context, value, child) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.black,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.only(left: 18.0),
              isExpanded: true,
              items: languages.keys.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Center(
                    child: Text(
                      language,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  outputNotifier.value = newvalue!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

// Translation screen widget
class LanguageTranslation extends StatefulWidget {
  const LanguageTranslation({super.key});

  @override
  State<LanguageTranslation> createState() => _LanguageTranslationState();
}

class _LanguageTranslationState extends State<LanguageTranslation> {
  // Controllers for input and output text fields
  final TextEditingController controllerInput = TextEditingController();
  final TextEditingController controllerOutput = TextEditingController();
  String inputText = '';
  String outputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              subTitleTrans(), // Title
              const SizedBox(height: 20),
              inputTransChange(), // Input language dropdown button
              inputTransField(), // Input text field
              const SizedBox(height: 20),
              TransSwitch(), // Swap input and output languages
              const SizedBox(height: 20),
              outputTransChange(), // Output language dropdown button
              outputTransField(), // Output text field

              const SizedBox(height: 30),

              TranslateButton(), // Button to peform translation
            ],
          ),
        ),
      ),
    );
  }

  Padding TranslateButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          minimumSize: const Size(80, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () async {
          // Get language codes from selected dropdown values
          String fromLangCode = langCode(inputNotifier.value);
          String toLangCode = langCode(outputNotifier.value);

          // Perform translation
          String translated = await translateText(
            controllerInput.text,
            fromLangCode,
            toLangCode,
          );

          setState(() {
            controllerOutput.text = translated; // Update output field
            outputText = translated; // Update state variable
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const LanguageTranslation(),
          //   ),
          // );
        },
        // child: ImageIcon(
        //   AssetImage('assets/translatorLogo.png'),
        //   color: Colors.white,
        //   size: 30,
        // ),
        child: Icon(
          Icons.translate, // Translation button icon
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Padding outputTransField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        maxLines: 3, // max visible lines
        keyboardType: TextInputType.multiline,
        controller: controllerOutput,
        onChanged: (value) {
          setState(() {
            outputText = value;
          });
        },
        style: TextStyle(
          color: Colors.white, // text color
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'What do you want to translate',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          // prefixIcon: Icon(Icons.enhanced_encryption),
          filled: true,
          fillColor: Colors.black,
          contentPadding: EdgeInsets.fromLTRB(20, 35, 12, 12),
          suffixIcon: IconButton(
            onPressed: () {
              controllerOutput.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  Padding outputTransChange() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          // border: Border.all(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        height: 50,
        child: ValueListenableBuilder<String>(
          valueListenable: outputNotifier,
          builder: (context, value, child) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.only(left: 18.0),
                isExpanded: true,
                items: languages.keys.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Center(
                      child: Text(
                        language,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    outputNotifier.value = newvalue!;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Container TransSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Transform.rotate(
        angle: 90 * 3.1415926535 / 180, // static 90° rotation
        child: AnimatedRotation(
          turns: turns,
          duration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            onPressed: () {
              setState(() {
                turns += 0.5; // 0.5 turns = 180°
                final temp = inputNotifier;
                inputNotifier = outputNotifier;
                outputNotifier = temp;
              });
              // print("Button Pressed");
            },
          ),
        ),
      ),
    );
  }

  Padding inputTransField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        maxLines: 3, // max visible lines
        keyboardType: TextInputType.multiline,
        controller: controllerInput,
        onChanged: (value) {
          setState(() {
            inputText = value;
          });
        },
        style: TextStyle(
          color: Colors.white, // text color
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'What do you want to translate',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          // prefixIcon: Icon(Icons.enhanced_encryption),
          filled: true,
          fillColor: Colors.black,
          contentPadding: EdgeInsets.fromLTRB(20, 35, 12, 12),
          suffixIcon: IconButton(
            onPressed: () {
              controllerInput.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  Padding inputTransChange() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          // border: Border.all(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        height: 50,
        child: ValueListenableBuilder<String>(
          valueListenable: inputNotifier,
          builder: (context, value, child) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.only(left: 18.0),
                isExpanded: true,
                items: languages.keys.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Center(
                      child: Text(
                        language,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    inputNotifier.value = newvalue!;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Text subTitleTrans() {
    return Text(
      "Translation",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: const Text(
      'Translator App',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        // color: Colors.white,
        color: Colors.blueAccent,
      ),
    ),
    centerTitle: true,
    elevation: 0,
    // backgroundColor: Colors.purpleAccent,
  );
}
