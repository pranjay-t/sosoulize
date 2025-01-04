import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/core/constants/type_def.dart';
import 'package:sosoulize/Cloud%20Storage/cloudinary_storage.dart';

final cloudinaryStorageProvider = Provider((ref) {
  return StorageRepository();
});

class StorageRepository {
  FutureEither<List<String>> storeFiles({
  required String path,
  required String id,
  required List<XFile> files,
  required List<Uint8List> webFiles,
  required bool isVideo, 
}) async {
  try {
    final List<String> uploadedUrls = [];
    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${Secret().cloudNameCloudinary}/upload');

    if (kIsWeb && webFiles.isNotEmpty) {
      // final request = http.MultipartRequest('POST', uri)
      //   ..fields['upload_preset'] = Secret().uploadPresetCloudinary
      //   ..fields['api_key'] = Secret().apiKeyCloudinary
      //   ..fields['public_id'] = '$path/$id'
      //   ..fields['resource_type'] = isVideo ? 'video' : 'image'
      //   ..files.add(http.MultipartFile.fromBytes(
      //     'file',
      //     webFile,
      //     filename: isVideo ? '$id.mp4' : '$id.jpg',
      //   ));

      // final response = await request.send();
      // final respStr = await response.stream.bytesToString();
      // final data = json.decode(respStr);
      // uploadedUrls.add(data['secure_url']);
      for (int i = 0; i < webFiles.length; i++) {
          final request = http.MultipartRequest('POST', uri)
            ..fields['upload_preset'] = Secret().uploadPresetCloudinary
            ..fields['api_key'] = Secret().apiKeyCloudinary
            ..fields['public_id'] = '$path/${id}_webfile_$i'
            ..fields['resource_type'] = isVideo ? 'video' : 'image'
            ..files.add(http.MultipartFile.fromBytes(
              'file',
              webFiles[i],
              filename: isVideo ? '${id}_webfile_$i.mp4' : '${id}_webfile_$i.jpg',
            ));

          final response = await request.send();
          final respStr = await response.stream.bytesToString();
          final data = json.decode(respStr);
          uploadedUrls.add(data['secure_url']);
        }
    } else if (!kIsWeb && files.isNotEmpty) {
      for (var file in files) {
        final request = http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = Secret().uploadPresetCloudinary
          ..fields['api_key'] = Secret().apiKeyCloudinary
          ..fields['public_id'] = '$path/${id}_${file.name}'
          ..fields['resource_type'] = isVideo ? 'video' : 'image'
          ..files.add(await http.MultipartFile.fromPath('file', file.path));

        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        uploadedUrls.add(data['secure_url']);
      }
    } else {
      throw Exception('No valid file provided for upload.');
    }

    return right(uploadedUrls);
  } catch (e) {
    return left(Failure(e.toString()));
  }
}

}
