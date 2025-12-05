import 'dart:io';
import 'package:sellerproof/core/utils/result.dart';

abstract class VideoRepository {
  Future<Result<void, String>> uploadVideo(File file);
}
