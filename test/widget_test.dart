import 'package:flutter_test/flutter_test.dart';
import 'package:movie_catalog/main.dart';

void main() {
  testWidgets('shows movie catalog list', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieCatalogApp());

    expect(find.text('Movie Catalog'), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Interstellar'), findsOneWidget);
    expect(find.text('8.4'), findsOneWidget);
  });

  testWidgets('opens movie detail page', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieCatalogApp());

    await tester.tap(find.text('Inception'));
    await tester.pumpAndSettle();

    expect(find.text('Deskripsi'), findsOneWidget);
    expect(find.text('Tambah ke Favorite'), findsOneWidget);
    expect(find.text('Inception'), findsNWidgets(2));
  });

  testWidgets('toggles favorite from list and detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MovieCatalogApp());

    await tester.tap(find.byTooltip('Tambah favorite').first);
    await tester.pump();

    expect(find.byTooltip('Hapus dari favorite'), findsOneWidget);

    await tester.tap(find.text('Inception'));
    await tester.pumpAndSettle();

    expect(find.text('Hapus dari Favorite'), findsOneWidget);

    await tester.tap(find.text('Hapus dari Favorite'));
    await tester.pump();

    expect(find.text('Tambah ke Favorite'), findsOneWidget);
  });

  testWidgets('shows favorite dropdown and removes favorite from it', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MovieCatalogApp());

    await tester.tap(find.byTooltip('Tambah favorite').first);
    await tester.pump();

    await tester.tap(find.byTooltip('Daftar favorite'));
    await tester.pumpAndSettle();

    expect(find.text('Inception'), findsNWidgets(2));

    await tester.tap(find.text('Inception').last);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Tambah favorite').first, findsOneWidget);
  });
}
