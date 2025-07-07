import 'dart:io';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';

class WeedDetectionRemoteDataSource {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isModelLoaded = false;

  final Map<String, String> _labelTranslations = {
    "Corn_Cercospora_leaf_spot Gray_leaf_spot": "Corn_Cercospora_leaf_spot Gray_leaf_spot",
    "Corn_healthy": "Corn_healthy",
    "Corn_Northern_Leaf_Blight": "Corn_Northern_Leaf_Blight",
    "Potato___Early_blight": "Potato___Early_blight",
    "Potato___healthy": "Potato___healthy",
    "Potato___Late_blight": "Potato___Late_blight",
    "Weeds": "Weeds",
    "Wheat_brown_rust": "Wheat_brown_rust",
    "Wheat___Healthy": "Wheat___Healthy",
  };


  final Map<String, Map<String, Map<String, String>>> _diseaseDetails = {
    "Corn_Cercospora_leaf_spot Gray_leaf_spot": {
      "en": {
        "scientific": "Corn_Cercospora_leaf_spot_Gray_leaf_spot_scientific",
        "description": "Corn_Cercospora_leaf_spot_Gray_leaf_spot_description"
      },
      "ar": {
        "scientific": "سيركوسبورا زيا-مايديس",
        "description": "البقعة الرمادية في أوراق الذرة تسبب آفات مستطيلة رمادية وتقلل من التمثيل الضوئي وغلة الذرة."
      }
    },
    "Corn_healthy": {
      "en": {
        "scientific": "Corn_healthy_scientific",
        "description": "Corn_healthy_description"
      },
      "ar": {
        "scientific": "لا يوجد",
        "description": "أوراق الذرة السليمة. لا يوجد مرض."
      }
    },
    "Corn_Northern_Leaf_Blight": {
      "en": {
        "scientific": "Corn_Northern_Leaf_Blight_scientific",
        "description": "Corn_Northern_Leaf_Blight_description"
      },
      "ar": {
        "scientific": "إكزسروهيلوم تورسيكوم",
        "description": "آفة الأوراق الشمالية في الذرة تسبب آفات رمادية خضراء طويلة وتؤدي إلى موت الأوراق المبكر."
      }
    },
    "Potato___Early_blight": {
      "en": {
        "scientific": "Potato___Early_blight_scientific",
        "description": "Potato___Early_blight_description"
      },
      "ar": {
        "scientific": "ألترناريا سولاني",
        "description": "الآفة المبكرة في البطاطس تسبب بقع داكنة دائرية وتؤدي إلى تساقط الأوراق وتقليل إنتاج الدرنات."
      }
    },
    "Potato___healthy": {
      "en": {
        "scientific": "Potato___healthy_scientific",
        "description": "Potato___healthy_description"
      },
      "ar": {
        "scientific": "لا يوجد",
        "description": "أوراق البطاطس السليمة. لا يوجد مرض."
      }
    },
    "Potato___Late_blight": {
      "en": {
        "scientific": "Potato___Late_blight_scientific",
        "description": "Potato___Late_blight_description"
      },
      "ar": {
        "scientific": "فيتوفثورا إنفستانس",
        "description": "الآفة المتأخرة في البطاطس تسبب آفات بنية مشبعة بالماء واشتهرت بسبب المجاعة الأيرلندية."
      }
    },
    "Weeds": {
      "en": {
        "scientific": "Weeds_scientific",
        "description": "Weeds_description"
      },
      "ar": {
        "scientific": "أنواع متعددة",
        "description": "الأعشاب الضارة تنافس المحاصيل على الموارد، مما يقلل من صحتها وغلتها."
      }
    },
    "Wheat_brown_rust": {
      "en": {
        "scientific": "Wheat_brown_rust_scientific",
        "description": "Wheat_brown_rust_description"
      },
      "ar": {
        "scientific": "بوسينيا تريتيكينا",
        "description": "الصدأ البني في القمح يظهر كبثور بنية حمراء ويؤثر على إنتاج القمح."
      }
    },
    "Wheat___Healthy": {
      "en": {
        "scientific": "Wheat___Healthy_scientific",
        "description": "Wheat___Healthy_description"
      },
      "ar": {
        "scientific": "لا يوجد",
        "description": "القمح السليم. لا يوجد مرض."
      }
    },
  };

  Future<void> loadModel() async {
    try {
      // Load model
      _interpreter = await Interpreter.fromAsset('assets/Plant_Diseases_Model.tflite');

      // Load labels
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n')
          .where((label) => label.trim().isNotEmpty)
          .map((label) => label.trim())
          .toList();

      _isModelLoaded = true;
    } catch (e) {
      _isModelLoaded = false;
      throw Exception('Failed to load model: $e');
    }
  }

  Future<Map<String, dynamic>> detectWeeds(File imageFile) async {
    if (!_isModelLoaded) {
      throw Exception(AppStrings.generalError.tr());
    }

    try {
      final inputTensor = await _preprocessImage(imageFile);

      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
      _interpreter.run(inputTensor, output);

      final probabilities = List<double>.from(output[0]);
      final predictedIndex = probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));
      final predictedLabel = _labels[predictedIndex].trim();

      final translatedLabel = _labelTranslations[predictedLabel] ?? predictedLabel;
      final details = _getDiseaseDetails(predictedLabel);

      return {
        'label': translatedLabel,
        'scientific': details['scientific'] ?? AppStrings.generalError.tr(),
        'description': details['description'] ?? AppStrings.generalError.tr(),
      };
    } catch (e) {
      throw Exception(AppStrings.generalError.tr());
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();

      final image = img.decodeImage(imageBytes)!;
      final resizedImage = img.copyResize(image, width: 224, height: 224);

      final input = List.generate(
        224,
            (y) => List.generate(
          224,
              (x) => [
            resizedImage.getPixel(x, y).r / 255.0, // Normalize red channel
            resizedImage.getPixel(x, y).g / 255.0, // Normalize green channel
            resizedImage.getPixel(x, y).b / 255.0, // Normalize blue channel
          ],
        ),
      );

      return [input]; // Add batch dimension
    } catch (e) {
      throw Exception(AppStrings.generalError.tr());
    }
  }

  Map<String, String> _getDiseaseDetails(String label) {
    final defaultDetails = {
      'scientific': AppStrings.generalError.tr(),
      'description': AppStrings.generalError.tr()
    };

    try {
      final diseaseInfo = _diseaseDetails[label]?['en'] ?? defaultDetails;
      return {
        'scientific': diseaseInfo['scientific'] ?? defaultDetails['scientific']!,
        'description': diseaseInfo['description'] ?? defaultDetails['description']!,
      };
    } catch (e) {
      return defaultDetails;
    }
  }

  void dispose() {
    _interpreter.close();
  }
}