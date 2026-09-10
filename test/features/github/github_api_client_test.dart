import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/features/github/data/datasources/github_api_client.dart';
import 'package:libora/features/github/domain/exceptions/github_exception.dart';

void main() {
  group('GitHubApiClient Tests', () {
    late Dio dio;
    late GitHubApiClient apiClient;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'));
      apiClient = GitHubApiClient(dio: dio);
    });

    test('uploadFile rejects files exceeding 100MB limit', () async {
      // Create a dummy byte list larger than 100MB
      final largeBytes = List<int>.filled(100 * 1024 * 1024 + 1, 0);

      expect(
        () => apiClient.uploadFile(
          owner: 'octocat',
          repo: 'test-repo',
          path: 'HugeBook.pdf',
          contentBytes: largeBytes,
          message: 'Upload large book',
          branch: 'main',
          token: 'ghp_fakeToken',
        ),
        throwsA(isA<GitHubFileSizeLimitException>()),
      );
    });

    test('validateToken handles successful user response', () async {
      dio.httpClientAdapter = _MockHttpAdapter((options) async {
        if (options.path == '/user') {
          return ResponseBody.fromString(
            '{"id": 583231, "login": "octocat", "name": "The Octocat", "avatar_url": "https://avatars.githubusercontent.com/u/583231"}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString('Not found', 404);
      });

      final user = await apiClient.validateToken('ghp_validToken');
      expect(user.id, equals(583231));
      expect(user.login, equals('octocat'));
      expect(user.name, equals('The Octocat'));
      expect(user.avatarUrl, equals('https://avatars.githubusercontent.com/u/583231'));
    });

    test('validateToken translates 401 to GitHubAuthException', () async {
      dio.httpClientAdapter = _MockHttpAdapter((options) async {
        return ResponseBody.fromString(
          '{"message": "Bad credentials"}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      expect(
        () => apiClient.validateToken('ghp_invalidToken'),
        throwsA(isA<GitHubAuthException>()),
      );
    });

    test('fetchUserRepositories parses repository list', () async {
      dio.httpClientAdapter = _MockHttpAdapter((options) async {
        if (options.path == '/user/repos') {
          return ResponseBody.fromString(
            '''[
              {
                "id": 1296269,
                "name": "Hello-World",
                "full_name": "octocat/Hello-World",
                "owner": {"login": "octocat"},
                "private": false,
                "default_branch": "master"
              },
              {
                "id": 1296270,
                "name": "My-Library",
                "full_name": "octocat/My-Library",
                "owner": {"login": "octocat"},
                "private": true,
                "default_branch": "main"
              }
            ]''',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString('Not found', 404);
      });

      final repos = await apiClient.fetchUserRepositories('ghp_validToken');
      expect(repos.length, equals(2));
      expect(repos[0].name, equals('Hello-World'));
      expect(repos[0].fullName, equals('octocat/Hello-World'));
      expect(repos[0].isPrivate, isFalse);
      expect(repos[1].name, equals('My-Library'));
      expect(repos[1].isPrivate, isTrue);
      expect(repos[1].defaultBranch, equals('main'));
    });

    test('fetchRepositoryTree returns empty tree for empty repo (404/409)', () async {
      dio.httpClientAdapter = _MockHttpAdapter((options) async {
        return ResponseBody.fromString(
          '{"message": "Git Repository is empty."}',
          409,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final tree = await apiClient.fetchRepositoryTree(
        owner: 'octocat',
        repo: 'empty-repo',
        branch: 'main',
        token: 'ghp_token',
      );
      expect(tree.tree, isEmpty);
    });

    test('rate limit translates 403 to GitHubRateLimitException', () async {
      dio.httpClientAdapter = _MockHttpAdapter((options) async {
        return ResponseBody.fromString(
          '{"message": "API rate limit exceeded"}',
          403,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
            'x-ratelimit-reset': ['1672531199'],
          },
        );
      });

      expect(
        () => apiClient.fetchUserRepositories('ghp_token'),
        throwsA(isA<GitHubRateLimitException>()),
      );
    });

    test('permission error translates 403 to GitHubPermissionException', () async {
      dio.httpClientAdapter = _MockHttpAdapter((options) async {
        return ResponseBody.fromString(
          '{"message": "Resource not accessible by personal access token"}',
          403,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      expect(
        () => apiClient.uploadFile(
          owner: 'octocat',
          repo: 'test-repo',
          path: 'Doc.pdf',
          contentBytes: [1, 2, 3],
          message: 'Add doc',
          branch: 'main',
          token: 'ghp_token',
        ),
        throwsA(isA<GitHubPermissionException>()),
      );
    });
  });
}

class _MockHttpAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _MockHttpAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      handler(options);

  @override
  void close({bool force = false}) {}
}

