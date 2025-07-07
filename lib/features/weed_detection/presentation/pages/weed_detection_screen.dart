// // ignore_for_file: use_build_context_synchronously
//
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:aqua_sol/resources/app_strings.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
//
// import '../../../../resources/app_color.dart';
//
// class WeedDetectionScreen extends StatefulWidget {
//   const WeedDetectionScreen({super.key});
//
//   @override
//   _WeedDetectionScreenState createState() => _WeedDetectionScreenState();
// }
//
// class _WeedDetectionScreenState extends State<WeedDetectionScreen> {
//   late Interpreter _interpreter;
//   late List<String> _labels;
//   File? _selectedImage;
//   Map<String, String>? _resultData;
//   final picker = ImagePicker();
//
//  final Map<String, String> _labelTranslations = {
//   "Corn_Cercospora_leaf_spot Gray_leaf_spot": "البقعة الرمادية في أوراق الذرة",
//   "Corn_healthy": "أوراق الذرة السليمة",
//   "Corn_Northern_Leaf_Blight": "آفة الأوراق الشمالية في الذرة",
//   "Potato___Early_blight": "الآفة المبكرة في البطاطس",
//   "Potato___healthy": "أوراق البطاطس السليمة",
//   "Potato___Late_blight": "الآفة المتأخرة في البطاطس",
//   "Weeds": "الأعشاب الضارة",
//   "Wheat_brown_rust": "الصدأ البني في القمح",
//   "Wheat___Healthy": "القمح السليم",
// };
// final Map<String, Map<String, Map<String, String>>> _localizedDiseaseDetails = {
//   "Corn_Cercospora_leaf_spot Gray_leaf_spot": {
//     "en": {
//       "scientific": "Cercospora zeae-maydis",
//       "description": "Gray leaf spot causes gray-tan rectangular lesions on corn leaves, reducing photosynthesis and yield."
//     },
//     "ar": {
//       "scientific": "سيركوسبورا زيا-مايديس",
//       "description": "البقعة الرمادية في أوراق الذرة تسبب آفات مستطيلة رمادية وتقلل من التمثيل الضوئي وغلة الذرة."
//     }
//   },
//   "Corn_healthy": {
//     "en": {
//       "scientific": "None",
//       "description": "Corn leaves are healthy. No disease detected."
//     },
//     "ar": {
//       "scientific": "لا يوجد",
//       "description": "أوراق الذرة السليمة. لا يوجد مرض."
//     }
//   },
//   "Corn_Northern_Leaf_Blight": {
//     "en": {
//       "scientific": "Exserohilum turcicum",
//       "description": "Northern Leaf Blight produces elongated gray-green lesions, leading to premature leaf death."
//     },
//     "ar": {
//       "scientific": "إكزسروهيلوم تورسيكوم",
//       "description": "آفة الأوراق الشمالية في الذرة تسبب آفات رمادية خضراء طويلة وتؤدي إلى موت الأوراق المبكر."
//     }
//   },
//   "Potato___Early_blight": {
//     "en": {
//       "scientific": "Alternaria solani",
//       "description": "Early blight causes dark concentric spots, leading to leaf drop and reduced tuber yield."
//     },
//     "ar": {
//       "scientific": "ألترناريا سولاني",
//       "description": "الآفة المبكرة في البطاطس تسبب بقع داكنة دائرية وتؤدي إلى تساقط الأوراق وتقليل إنتاج الدرنات."
//     }
//   },
//   "Potato___healthy": {
//     "en": {
//       "scientific": "None",
//       "description": "Potato leaves are healthy. No disease detected."
//     },
//     "ar": {
//       "scientific": "لا يوجد",
//       "description": "أوراق البطاطس السليمة. لا يوجد مرض."
//     }
//   },
//   "Potato___Late_blight": {
//     "en": {
//       "scientific": "Phytophthora infestans",
//       "description": "Late blight causes brown water-soaked lesions, known for the Irish Potato Famine."
//     },
//     "ar": {
//       "scientific": "فيتوفثورا إنفستانس",
//       "description": "الآفة المتأخرة في البطاطس تسبب آفات بنية مشبعة بالماء واشتهرت بسبب المجاعة الأيرلندية."
//     }
//   },
//   "Weeds": {
//     "en": {
//       "scientific": "Various species",
//       "description": "Weeds compete with crops for resources, lowering crop health and yield."
//     },
//     "ar": {
//       "scientific": "أنواع متعددة",
//       "description": "الأعشاب الضارة تنافس المحاصيل على الموارد، مما يقلل من صحتها وغلتها."
//     }
//   },
//   "Wheat_brown_rust": {
//     "en": {
//       "scientific": "Puccinia triticina",
//       "description": "Brown rust appears as reddish-brown pustules and affects wheat yield."
//     },
//     "ar": {
//       "scientific": "بوسينيا تريتيكينا",
//       "description": "الصدأ البني في القمح يظهر كبثور بنية حمراء ويؤثر على إنتاج القمح."
//     }
//   },
//   "Wheat___Healthy": {
//     "en": {
//       "scientific": "None",
//       "description": "Wheat is healthy. No disease present."
//     },
//     "ar": {
//       "scientific": "لا يوجد",
//       "description": "القمح السليم. لا يوجد مرض."
//     }
//   }
// };
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadModelAndLabels();
//   }
//
//   Future<void> _loadModelAndLabels() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/Plant_Diseases_Model.tflite');
//       String labelsData =
//           await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
//       _labels =
//           labelsData.split('\n').where((label) => label.isNotEmpty).toList();
//     } catch (e) {
//       setState(() {
//         _resultData = {
//           "label": "Error",
//
//           "scientific": "N/A",
//           "description": "Error loading model.",
//         };
//       });
//     }
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//       _runInference();
//     }
//   }
//
//   Future<void> _runInference() async {
//     if (_selectedImage == null) return;
//     try {
//       Uint8List imageBytes = await _selectedImage!.readAsBytes();
//       List inputTensor = _preprocess(imageBytes);
//
//       var output =
//           List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
//       _interpreter.run(inputTensor, output);
//
//       List<double> probabilities = List<double>.from(output[0]);
//       int predictedIndex =
//           probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));
//       String predictedLabel = _labels[predictedIndex];
//
//       final locale = Localizations.localeOf(context).languageCode;
//       String translatedLabel = locale == 'ar'
//           ? _labelTranslations[predictedLabel] ?? predictedLabel
//           : predictedLabel;
//
//       final details = _localizedDiseaseDetails[predictedLabel]?[locale] ??
//           _localizedDiseaseDetails[predictedLabel]?['en'];
//
//       setState(() {
//         _resultData = {
//           "label": translatedLabel,
//           "scientific": details?["scientific"] ?? "Unknown",
//           "description": details?["description"] ?? "No description available.",
//         };
//       });
//     } catch (e) {
//       setState(() {
//         _resultData = {
//           "label": "Prediction Error",
//           "scientific": "N/A",
//           "description": "Something went wrong during prediction.",
//         };
//       });
//     }
//   }
//
//   List _preprocess(Uint8List inputBytes) {
//     final image = img.decodeImage(inputBytes)!;
//     final resizedImage = img.copyResize(image, width: 224, height: 224);
//     return List.generate(
//         224,
//         (y) => List.generate(
//             224,
//             (x) => [
//                   resizedImage.getPixel(x, y).r / 255.0,
//                   resizedImage.getPixel(x, y).g / 255.0,
//                   resizedImage.getPixel(x, y).b / 255.0,
//                 ])).reshape([1, 224, 224, 3]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     final isArabic = locale == 'ar';
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // Font sizes are now based on the screen size directly
//     double fontSize(double scaleFactor) => screenWidth * scaleFactor;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.primaryColor,
//         title: Text(
//           AppStrings.weedDetection.tr(),
//           style: TextStyle(
//               color: AppColor.whiteColor, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SafeArea(
//         child: _selectedImage == null || _resultData == null
//             ? _buildPickerUI(context, screenHeight, screenWidth, fontSize)
//             : _buildResultUI(
//                 context, isArabic, screenHeight, screenWidth, fontSize),
//       ),
//     );
//   }
//
//
//
//   Widget _buildPickerUI(BuildContext context, double screenHeight,
//       double screenWidth, Function(double) fontSize) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             // Background image
//             Image.asset(
//               'assets/images/weed_detection_background.png',
//               width: screenWidth,
//               height: screenHeight * 0.6,
//               fit: BoxFit.cover,
//             ),
//             // Text at the bottom of the image
//             Positioned(
//               bottom: 10,
//               // Positioned at the bottom of the image with a small margin
//               left: 0,
//               right: 0,
//               child: Text(
//                 AppStrings.makeSureImageInFocus.tr(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: fontSize(0.05), // Responsively scale font size
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white, // White text color
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Spacer(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildIconButton(Icons.camera_alt, AppStrings.camera.tr(),
//                 () => _pickImage(ImageSource.camera), fontSize(0.05)),
//             SizedBox(width: screenWidth * 0.1),
//             _buildIconButton(Icons.photo_library, AppStrings.gallery.tr(),
//                 () => _pickImage(ImageSource.gallery), fontSize(0.05)),
//           ],
//         ),
//         SizedBox(height: screenHeight * 0.05),
//       ],
//     );
//   }
//
//   Widget _buildResultUI(BuildContext context, bool isArabic,
//       double screenHeight, double screenWidth, Function(double) fontSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.file(
//           _selectedImage!,
//           width: screenWidth,
//           height: screenHeight * 0.4,
//           fit: BoxFit.fitWidth,
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//           child: Text(
//             _resultData!["label"]!,
//             style: TextStyle(
//                 fontSize: fontSize(0.06), fontWeight: FontWeight.bold),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "${isArabic ? 'الاسم العلمي' : 'Scientific name'}:",
//                 style: TextStyle(
//                     fontSize: fontSize(0.05), color: Colors.grey[700]),
//               ),
//               Text(
//                 _resultData!["scientific"]!,
//                 style: TextStyle(
//                     fontSize: fontSize(0.047),
//                     fontStyle: FontStyle.italic,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//             ],
//           ),
//         ),
//         Divider(color: AppColor.lightGreyColor, thickness: 5),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             children: [
//               Icon(Icons.energy_savings_leaf_rounded,
//                   color: Colors.green, size: fontSize(0.07)),
//               SizedBox(width: screenWidth * 0.02),
//               Text(
//                 AppStrings.description.tr(),
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: fontSize(0.05)),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             _resultData!["description"]!,
//             style: TextStyle(fontSize: fontSize(0.045)),
//           ),
//         ),
//         Spacer(),
//         Divider(color: AppColor.black, thickness: 0.5),
//         Center(
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedImage = null;
//                 _resultData = null;
//               });
//             },
//             child: Column(
//               children: [
//                 Icon(Icons.camera_alt_outlined,
//                     color: Colors.purple, size: fontSize(0.07)),
//                 Text(AppStrings.newText.tr(),
//                     style: TextStyle(color: Colors.purple)),
//                 SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildIconButton(
//       IconData icon, String label, VoidCallback onTap, double fontSize) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: CircleAvatar(
//             radius: 30,
//             backgroundColor: AppColor.whiteColor,
//             child: Icon(icon, color: AppColor.greenColor, size: 30),
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: AppColor.black),
//         ),
//       ],
//     );
//   }
// }
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:aqua_sol/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../../resources/app_color.dart';

class WeedDetectionScreen extends StatefulWidget {
  const WeedDetectionScreen({super.key});

  @override
  _WeedDetectionScreenState createState() => _WeedDetectionScreenState();
}

class _WeedDetectionScreenState extends State<WeedDetectionScreen> {
  late Interpreter _interpreter;
  late List<String> _labels;
  File? _selectedImage;
  Map<String, String>? _resultData;
  final picker = ImagePicker();

  final Map<String, String> _labelTranslations = {
    "Corn_Cercospora_leaf_spot Gray_leaf_spot": "البقعة الرمادية في أوراق الذرة",
    "Corn_healthy": "أوراق الذرة السليمة",
    "Corn_Northern_Leaf_Blight": "آفة الأوراق الشمالية في الذرة",
    "Potato___Early_blight": "الآفة المبكرة في البطاطس",
    "Potato___healthy": "أوراق البطاطس السليمة",
    "Potato___Late_blight": "الآفة المتأخرة في البطاطس",
    "Weeds": "الأعشاب الضارة",
    "Wheat_brown_rust": "الصدأ البني في القمح",
    "Wheat___Healthy": "القمح السليم",
  };

  final Map<String, Map<String, Map<String, String>>> _localizedDiseaseDetails = {
    "Corn_Cercospora_leaf_spot Gray_leaf_spot": {
      "en": {
        "scientific": "Cercospora zeae-maydis",
        "description": "Gray leaf spot causes gray-tan rectangular lesions on corn leaves, reducing photosynthesis and yield."
      },
      "ar": {
        "scientific": "سيركوسبورا زيا-مايديس",
        "description": "البقعة الرمادية في أوراق الذرة تسبب آفات مستطيلة رمادية وتقلل من التمثيل الضوئي وغلة الذرة."
      }
    },
    "Corn_healthy": {
      "en": {
        "scientific": "None",
        "description": "Corn leaves are healthy. No disease detected."
      },
      "ar": {
        "scientific": "لا يوجد",
        "description": "أوراق الذرة السليمة. لا يوجد مرض."
      }
    },
    "Corn_Northern_Leaf_Blight": {
      "en": {
        "scientific": "Exserohilum turcicum",
        "description": "Northern Leaf Blight produces elongated gray-green lesions, leading to premature leaf death."
      },
      "ar": {
        "scientific": "إكزسروهيلوم تورسيكوم",
        "description": "آفة الأوراق الشمالية في الذرة تسبب آفات رمادية خضراء طويلة وتؤدي إلى موت الأوراق المبكر."
      }
    },
    "Potato___Early_blight": {
      "en": {
        "scientific": "Alternaria solani",
        "description": "Early blight causes dark concentric spots, leading to leaf drop and reduced tuber yield."
      },
      "ar": {
        "scientific": "ألترناريا سولاني",
        "description": "الآفة المبكرة في البطاطس تسبب بقع داكنة دائرية وتؤدي إلى تساقط الأوراق وتقليل إنتاج الدرنات."
      }
    },
    "Potato___healthy": {
      "en": {
        "scientific": "None",
        "description": "Potato leaves are healthy. No disease detected."
      },
      "ar": {
        "scientific": "لا يوجد",
        "description": "أوراق البطاطس السليمة. لا يوجد مرض."
      }
    },
    "Potato___Late_blight": {
      "en": {
        "scientific": "Phytophthora infestans",
        "description": "Late blight causes brown water-soaked lesions, known for the Irish Potato Famine."
      },
      "ar": {
        "scientific": "فيتوفثورا إنفستانس",
        "description": "الآفة المتأخرة في البطاطس تسبب آفات بنية مشبعة بالماء واشتهرت بسبب المجاعة الأيرلندية."
      }
    },
    "Weeds": {
      "en": {
        "scientific": "Various species",
        "description": "Weeds compete with crops for resources, lowering crop health and yield."
      },
      "ar": {
        "scientific": "أنواع متعددة",
        "description": "الأعشاب الضارة تنافس المحاصيل على الموارد، مما يقلل من صحتها وغلتها."
      }
    },
    "Wheat_brown_rust": {
      "en": {
        "scientific": "Puccinia triticina",
        "description": "Brown rust appears as reddish-brown pustules and affects wheat yield."
      },
      "ar": {
        "scientific": "بوسينيا تريتيكينا",
        "description": "الصدأ البني في القمح يظهر كبثور بنية حمراء ويؤثر على إنتاج القمح."
      }
    },
    "Wheat___Healthy": {
      "en": {
        "scientific": "None",
        "description": "Wheat is healthy. No disease present."
      },
      "ar": {
        "scientific": "لا يوجد",
        "description": "القمح السليم. لا يوجد مرض."
      }
    }
  };

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/Plant_Diseases_Model.tflite');
      String labelsData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelsData.split('\n')
          .where((label) => label.trim().isNotEmpty)
          .map((label) => label.trim())
          .toList();
      print('Labels loaded: $_labels'); // Debug print
    } catch (e) {
      print('Error loading model: $e');
      setState(() {
        _resultData = {
          "label": "Error",
          "scientific": "N/A",
          "description": "Error loading model.",
        };
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _resultData = null; // Reset result when new image is selected
      });
      await _runInference();
    }
  }

  Future<void> _runInference() async {
    if (_selectedImage == null) return;
    try {
      Uint8List imageBytes = await _selectedImage!.readAsBytes();
      List inputTensor = _preprocess(imageBytes);

      var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
      _interpreter.run(inputTensor, output);

      List<double> probabilities = List<double>.from(output[0]);
      int predictedIndex = probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));
      String predictedLabel = _labels[predictedIndex].trim();

      print('Predicted Label: $predictedLabel');
      print('Available Translations: ${_labelTranslations.keys}');

      final locale = Localizations.localeOf(context).languageCode;

      // Find the best matching translation
      String translatedLabel = predictedLabel;
      if (locale == 'ar') {
        translatedLabel = _labelTranslations[predictedLabel] ??
            _labelTranslations.entries.firstWhere(
                    (entry) => entry.key.trim().toLowerCase() == predictedLabel.toLowerCase(),
                orElse: () => MapEntry(predictedLabel, predictedLabel)
            ).value;
      }

      // Find the best matching details
      Map<String, String>? details = _localizedDiseaseDetails[predictedLabel]?[locale] ??
          _localizedDiseaseDetails[predictedLabel]?['en'] ??
          _localizedDiseaseDetails.entries.firstWhere(
                  (entry) => entry.key.trim().toLowerCase() == predictedLabel.toLowerCase(),
              orElse: () => MapEntry(predictedLabel, {'en': {
                'scientific': 'Unknown',
                'description': 'No information available for this detection.'
              }})
          ).value[locale] ?? {'en': {
        'scientific': 'Unknown',
        'description': 'No information available for this detection.'
      }}['en'];

      setState(() {
        _resultData = {
          "label": translatedLabel,
          "scientific": details?["scientific"] ?? "Unknown",
          "description": details?["description"] ?? "No description available.",
        };
      });

    } catch (e) {
      print('Error during inference: $e');
      setState(() {
        _resultData = {
          "label": "Prediction Error",
          "scientific": "N/A",
          "description": "Something went wrong during prediction.",
        };
      });
    }
  }

  List _preprocess(Uint8List inputBytes) {
    final image = img.decodeImage(inputBytes)!;
    final resizedImage = img.copyResize(image, width: 224, height: 224);
    return List.generate(
        224,
            (y) => List.generate(
            224,
                (x) => [
              resizedImage.getPixel(x, y).r / 255.0,
              resizedImage.getPixel(x, y).g / 255.0,
              resizedImage.getPixel(x, y).b / 255.0,
            ])).reshape([1, 224, 224, 3]);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Font sizes are now based on the screen size directly
    double fontSize(double scaleFactor) => screenWidth * scaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          AppStrings.weedDetection.tr(),
          style: TextStyle(
              color: AppColor.whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: _selectedImage == null || _resultData == null
            ? _buildPickerUI(context, screenHeight, screenWidth, fontSize)
            : _buildResultUI(
            context, isArabic, screenHeight, screenWidth, fontSize),
      ),
    );
  }

  Widget _buildPickerUI(BuildContext context, double screenHeight,
      double screenWidth, Function(double) fontSize) {
    return Column(
      children: [
        Stack(
          children: [
            // Background image
            Image.asset(
              'assets/images/weed_detection_background.png',
              width: screenWidth,
              height: screenHeight * 0.6,
              fit: BoxFit.cover,
            ),
            // Text at the bottom of the image
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Text(
                AppStrings.makeSureImageInFocus.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize(0.05),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(Icons.camera_alt, AppStrings.camera.tr(),
                    () => _pickImage(ImageSource.camera), fontSize(0.05)),
            SizedBox(width: screenWidth * 0.1),
            _buildIconButton(Icons.photo_library, AppStrings.gallery.tr(),
                    () => _pickImage(ImageSource.gallery), fontSize(0.05)),
          ],
        ),
        SizedBox(height: screenHeight * 0.05),
      ],
    );
  }

  Widget _buildResultUI(BuildContext context, bool isArabic,
      double screenHeight, double screenWidth, Function(double) fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.file(
          _selectedImage!,
          width: screenWidth,
          height: screenHeight * 0.4,
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text(
            _resultData!["label"]!,
            style: TextStyle(
                fontSize: fontSize(0.06), fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${isArabic ? 'الاسم العلمي' : 'Scientific name'}:",
                style: TextStyle(
                    fontSize: fontSize(0.05), color: Colors.grey[700]),
              ),
              Text(
                _resultData!["scientific"]!,
                style: TextStyle(
                    fontSize: fontSize(0.047),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
        Divider(color: AppColor.lightGreyColor, thickness: 5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.energy_savings_leaf_rounded,
                  color: Colors.green, size: fontSize(0.07)),
              SizedBox(width: screenWidth * 0.02),
              Text(
                AppStrings.description.tr(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: fontSize(0.05)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _resultData!["description"]!,
            style: TextStyle(fontSize: fontSize(0.045)),
          ),
        ),
        Spacer(),
        Divider(color: AppColor.black, thickness: 0.5),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImage = null;
                _resultData = null;
              });
            },
            child: Column(
              children: [
                Icon(Icons.camera_alt_outlined,
                    color: Colors.purple, size: fontSize(0.07)),
                Text(AppStrings.newText.tr(),
                    style: TextStyle(color: Colors.purple)),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
      IconData icon, String label, VoidCallback onTap, double fontSize) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColor.whiteColor,
            child: Icon(icon, color: AppColor.greenColor, size: 30),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColor.black),
        ),
      ],
    );
  }
}