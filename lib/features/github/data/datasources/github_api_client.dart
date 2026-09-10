import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/exceptions/github_exception.dart';
import '../models/github_repo_dto.dart';
import '../models/github_tree_dto.dart';
import '../models/github_user_dto.dart';

abstract class IGitHubApiClient {
  Future<GitHubUserDto> validateToken(String token);
  Future<List<GitHubRepoDto>> fetchUserRepositories(String token, {int page = 1, int perPage = 100});
  Future<GitHubTreeDto> fetchRepositoryTree({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  });
  Future<List<int>> downloadFileBytes({
    required String owner,
    required String repo,
    required String path,
    required String branch,
    required String token,
    void Function(int received, int total)? onProgress,
  });
  Future<Map<String, dynamic>> uploadFile({
    required String owner,
    required String repo,
    required String path,
    required List<int> contentBytes,
    required String message,
    required String branch,
    String? sha,
    required String token,
    void Function(int sent, int total)? onProgress,
  });
  Future<void> deleteFile({
    required String owner,
    required String repo,
    required String path,
    required String sha,
    required String message,
    required String branch,
    required String token,
  });
}

class GitHubApiClient implements IGitHubApiClient {
  final Dio _dio;
  static const String _baseUrl = 'https://api.github.com';

  GitHubApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 60),
                sendTimeout: const Duration(seconds: 60),
                headers: {
                  'Accept': 'application/vnd.github+json',
                  'X-GitHub-Api-Version': '2022-11-28',
                  'User-Agent': 'Libora-App',
                },
              ),
            );

  Options _authOptions(String token, {String? accept, ResponseType? responseType}) {
    final headers = <String, dynamic>{
      'Authorization': 'Bearer $token',
    };
    if (accept != null) {
      headers['Accept'] = accept;
    }
    return Options(
      headers: headers,
      responseType: responseType ?? ResponseType.json,
    );
  }

  @override
  Future<GitHubUserDto> validateToken(String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/user',
        options: _authOptions(token),
      );
      if (response.data == null) {
        throw const GitHubUnknownException('Empty response from GitHub /user endpoint');
      }
      return GitHubUserDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is GitHubException) rethrow;
      throw GitHubUnknownException(e.toString(), e);
    }
  }

  @override
  Future<List<GitHubRepoDto>> fetchUserRepositories(
    String token, {
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/user/repos',
        queryParameters: {
          'sort': 'updated',
          'per_page': perPage,
          'page': page,
          'affiliation': 'owner,collaborator,organization_member',
        },
        options: _authOptions(token),
      );

      final data = response.data ?? [];
      return data
          .map((item) => GitHubRepoDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is GitHubException) rethrow;
      throw GitHubUnknownException(e.toString(), e);
    }
  }

  @override
  Future<GitHubTreeDto> fetchRepositoryTree({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/repos/$owner/$repo/git/trees/$branch',
        queryParameters: {'recursive': '1'},
        options: _authOptions(token),
      );

      if (response.data == null) {
        return const GitHubTreeDto(sha: '', tree: []);
      }
      return GitHubTreeDto.fromJson(response.data!);
    } on DioException catch (e) {
      // Empty repo returns 404 or 409
      if (e.response?.statusCode == 404 || e.response?.statusCode == 409) {
        final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
        if (msg.contains('empty') || msg.contains('git repository is empty')) {
          AppLogger.info('Repository is empty: $owner/$repo', tag: 'GitHubApiClient');
          return const GitHubTreeDto(sha: '', tree: []);
        }
      }
      throw _handleDioError(e);
    } catch (e) {
      if (e is GitHubException) rethrow;
      throw GitHubUnknownException(e.toString(), e);
    }
  }

  @override
  Future<List<int>> downloadFileBytes({
    required String owner,
    required String repo,
    required String path,
    required String branch,
    required String token,
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      // Use raw header to stream direct binary bytes
      final encodedPath = Uri.encodeFull(path);
      final response = await _dio.get<List<dynamic>>(
        '/repos/$owner/$repo/contents/$encodedPath',
        queryParameters: {'ref': branch},
        options: _authOptions(
          token,
          accept: 'application/vnd.github.raw',
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: onProgress,
      );

      if (response.data is List<int>) {
        return response.data as List<int>;
      } else if (response.data is List) {
        return List<int>.from(response.data!);
      }
      throw const GitHubUnknownException('Unexpected binary response format');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is GitHubException) rethrow;
      throw GitHubUnknownException(e.toString(), e);
    }
  }

  @override
  Future<Map<String, dynamic>> uploadFile({
    required String owner,
    required String repo,
    required String path,
    required List<int> contentBytes,
    required String message,
    required String branch,
    String? sha,
    required String token,
    void Function(int sent, int total)? onProgress,
  }) async {
    const maxSizeBytes = 100 * 1024 * 1024; // 100MB GitHub limit
    if (contentBytes.length > maxSizeBytes) {
      throw GitHubFileSizeLimitException(
        fileSize: contentBytes.length,
        limitBytes: maxSizeBytes,
      );
    }

    try {
      final base64Content = base64Encode(contentBytes);
      final encodedPath = Uri.encodeFull(path);

      final payload = <String, dynamic>{
        'message': message,
        'content': base64Content,
        'branch': branch,
      };
      if (sha != null && sha.isNotEmpty) {
        payload['sha'] = sha;
      }

      final response = await _dio.put<Map<String, dynamic>>(
        '/repos/$owner/$repo/contents/$encodedPath',
        data: payload,
        options: _authOptions(token),
        onSendProgress: onProgress,
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is GitHubException) rethrow;
      throw GitHubUnknownException(e.toString(), e);
    }
  }

  @override
  Future<void> deleteFile({
    required String owner,
    required String repo,
    required String path,
    required String sha,
    required String message,
    required String branch,
    required String token,
  }) async {
    try {
      final encodedPath = Uri.encodeFull(path);
      final payload = <String, dynamic>{
        'message': message,
        'sha': sha,
        'branch': branch,
      };

      await _dio.delete(
        '/repos/$owner/$repo/contents/$encodedPath',
        data: payload,
        options: _authOptions(token),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is GitHubException) rethrow;
      throw GitHubUnknownException(e.toString(), e);
    }
  }

  GitHubException _handleDioError(DioException e) {
    AppLogger.error('GitHub API error: ${e.message}, status: ${e.response?.statusCode}', tag: 'GitHubApiClient');

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const GitHubNetworkException('Unable to reach GitHub. Please check your internet connection.');
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      return const GitHubAuthException();
    } else if (statusCode == 403 || statusCode == 429) {
      final resetHeader = e.response?.headers.value('x-ratelimit-reset');
      DateTime? resetTime;
      if (resetHeader != null) {
        final epochSeconds = int.tryParse(resetHeader);
        if (epochSeconds != null) {
          resetTime = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
        }
      }
      return GitHubRateLimitException(resetTime: resetTime);
    } else if (statusCode == 404) {
      return const GitHubNotFoundException();
    } else if (statusCode == 409) {
      return const GitHubConflictException();
    }

    final responseMsg = e.response?.data is Map<String, dynamic>
        ? e.response?.data['message']?.toString()
        : null;

    return GitHubUnknownException(
      responseMsg ?? e.message ?? 'Unknown GitHub error',
      e,
      statusCode,
    );
  }
}
