import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_catalog/repositories/movie_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('getMovies fetches API data and stores it in cache', () async {
    final repository = MovieRepository(
      dio: _dioWithAdapter(
        _QueueHttpClientAdapter([_successResponse(_movieApiPayload)]),
      ),
      preferences: SharedPreferences.getInstance(),
    );

    final result = await repository.getMovies();

    expect(result.isFromCache, isFalse);
    expect(result.movies, hasLength(1));
    expect(result.movies.first.title, 'Castle in the Sky');
    expect(result.movies.first.rating, 9.6);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('cached_movies'), isNotNull);
  });

  test('getMovies returns cached data when API fails', () async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('cached_movies', jsonEncode(_movieApiPayload));

    final repository = MovieRepository(
      dio: _dioWithAdapter(_QueueHttpClientAdapter([_failedResponse()])),
      preferences: SharedPreferences.getInstance(),
    );

    final result = await repository.getMovies();

    expect(result.isFromCache, isTrue);
    expect(result.movies.single.title, 'Castle in the Sky');
  });
}

Dio _dioWithAdapter(HttpClientAdapter adapter) {
  final dio = Dio();
  dio.httpClientAdapter = adapter;
  return dio;
}

ResponseBody _successResponse(List<Map<String, Object>> payload) {
  return ResponseBody.fromString(
    jsonEncode(payload),
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

ResponseBody _failedResponse() {
  return ResponseBody.fromString(
    'Server error',
    500,
    headers: {
      Headers.contentTypeHeader: [Headers.textPlainContentType],
    },
  );
}

class _QueueHttpClientAdapter implements HttpClientAdapter {
  _QueueHttpClientAdapter(this._responses);

  final List<ResponseBody> _responses;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_responses.isEmpty) {
      throw StateError('No fake HTTP response configured.');
    }

    return _responses.removeAt(0);
  }

  @override
  void close({bool force = false}) {}
}

const _movieApiPayload = [
  {
    'id': '2baf70d1-42bb-4437-b551-e5fed5a87abe',
    'title': 'Castle in the Sky',
    'release_date': '1986',
    'rt_score': '96',
    'description': 'A girl and a boy search for a legendary floating city.',
    'image': 'https://example.com/poster.jpg',
    'movie_banner': 'https://example.com/banner.jpg',
    'director': 'Hayao Miyazaki',
    'producer': 'Isao Takahata',
    'running_time': '124',
  },
];
