import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secret {
  final String apiKeyCloudinary = dotenv.env['Cloudinary_Api_Key']!;
  final String uploadPresetCloudinary = dotenv.env['Cloudinary_UploadPreset']!;
  final String cloudNameCloudinary = dotenv.env['Cloudinary_CloudName']!;

}