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
}
