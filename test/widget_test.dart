import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_catalog/main.dart';
import 'package:movie_catalog/models/movie.dart';
import 'package:movie_catalog/repositories/movie_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeMovieRepository extends MovieRepository {
  @override
  Future<MovieResult> getMovies() async {
    return const MovieResult(
      movies: [
        Movie(
          id: 'castle-in-the-sky',
          title: 'Castle in the Sky',
          releaseDate: '1986',
          rating: 9.6,
          description: 'A girl and a boy search for a legendary floating city.',
          imageUrl: 'https://example.com/poster.jpg',
          bannerUrl: 'https://example.com/banner.jpg',
          director: 'Hayao Miyazaki',
          producer: 'Isao Takahata',
          runningTime: '124',
        ),
        Movie(
          id: 'totoro',
          title: 'My Neighbor Totoro',
          releaseDate: '1988',
          rating: 9.3,
          description: 'Two sisters discover magical forest spirits.',
          imageUrl: 'https://example.com/totoro.jpg',
          bannerUrl: 'https://example.com/totoro-banner.jpg',
          director: 'Hayao Miyazaki',
          producer: 'Hayao Miyazaki',
          runningTime: '86',
        ),
      ],
      isFromCache: false,
    );
  }

  @override
  Stream<int> getActiveUsersCount() {
    return Stream.value(1500);
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows movie catalog list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MovieCatalogApp(movieRepository: FakeMovieRepository()),
    );
    await tester.pump();

    expect(find.text('Movie Catalog'), findsOneWidget);
    expect(find.text('Castle in the Sky'), findsOneWidget);
    expect(find.text('My Neighbor Totoro'), findsOneWidget);
    expect(find.text('9.6'), findsOneWidget);
  });

  testWidgets('opens movie detail page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MovieCatalogApp(movieRepository: FakeMovieRepository()),
    );
    await tester.pump();

    await tester.tap(find.text('Castle in the Sky'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah ke Favorite'), findsOneWidget);
    expect(find.text('Hayao Miyazaki'), findsWidgets);
    expect(find.text('Castle in the Sky'), findsNWidgets(2));

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Deskripsi'), findsOneWidget);
  });

  testWidgets('toggles favorite from list and detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MovieCatalogApp(movieRepository: FakeMovieRepository()),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Tambah favorite').first);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Hapus dari favorite'), findsOneWidget);

    await tester.tap(find.text('Castle in the Sky'));
    await tester.pumpAndSettle();

    expect(find.text('Hapus dari Favorite'), findsOneWidget);

    await tester.tap(find.text('Hapus dari Favorite'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah ke Favorite'), findsOneWidget);
  });

  testWidgets('shows favorite count in the app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MovieCatalogApp(movieRepository: FakeMovieRepository()),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Tambah favorite').first);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Daftar favorite'));
    await tester.pumpAndSettle();

    expect(find.text('Anda memiliki 1 film favorit'), findsOneWidget);
  });
}
