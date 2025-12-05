import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/datasources/remote/api_client.dart';
import 'package:sellerproof/data/models/api_models.dart';
import 'package:sellerproof/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final ApiClient _apiClient;

  VideoRepositoryImpl(this._apiClient);

  @override
  Future<Result<void, String>> uploadVideo(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final fileSize = await file.length();

      final initResponse = await _apiClient.initiateUpload(
        InitiateMultipartUploadRequest(
          fileName: fileName,
          fileSizeBytes: fileSize,
        ),
      );

      final partSize = initResponse.recommendedPartSizeMb * 1024 * 1024;
      final totalParts = (fileSize / partSize).ceil();

      final urlsResponse = await _apiClient.getUploadUrls(
        GetPartUploadURLsRequest(
          videoId: initResponse.videoId,
          totalParts: totalParts,
        ),
      );

      final completedParts = <CompletedPart>[];
      final fileAccess = await file.open();
      final uploadDio = Dio();

      for (int i = 0; i < totalParts; i++) {
        final start = i * partSize;
        final end = (start + partSize < fileSize) ? start + partSize : fileSize;
        final length = end - start;

        await fileAccess.setPosition(start);
        final chunk = await fileAccess.read(length);

        final response = await uploadDio.put(
          urlsResponse.partUrls[i],
          data: Stream.fromIterable([chunk]),
          options: Options(headers: {Headers.contentLengthHeader: length}),
        );

        final etag = response.headers.value('etag')?.replaceAll('"', '') ?? '';
        completedParts.add(CompletedPart(partNumber: i + 1, etag: etag));
      }
      uploadDio.close();
      await fileAccess.close();

      await _apiClient.completeUpload(
        CompleteMultipartUploadRequest(
          videoId: initResponse.videoId,
          parts: completedParts,
        ),
      );

      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
