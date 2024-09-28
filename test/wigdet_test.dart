import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kaapi_picker/cubit/coffee_cubit.dart';
import 'package:kaapi_picker/cubit/coffee_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });
  group('Coffee Cubit Widget tests', () {
    late CoffeeCubit coffeeCubit;
    late http.Client mockClient;

    setUp(() {
      mockClient = _MockHttpClient();
      coffeeCubit = CoffeeCubit(client: mockClient);
    });

    tearDown(() {
      coffeeCubit.close();
    });

    blocTest<CoffeeCubit, CoffeeState>(
      'Emits [CoffeeLoading, CoffeeSuccess] when successful',
      build: () => coffeeCubit,
      act: (cubit) async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async =>
              http.Response('{"file": "http://sample.com/coffee.jpg"}', 200),
        );
        await cubit.fetchImageUrl();
      },
      expect: () =>
          [CoffeeLoading(), CoffeeSuccess('http://sample.com/coffee.jpg')],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'Emits [CoffeeLoading, CoffeeError] when there is an error',
      build: () => CoffeeCubit(client: mockClient),
      act: (cubit) async {
        when(() => mockClient.get(any()))
            .thenThrow(Exception('Failed to fetch image'));
        await cubit.fetchImageUrl();
      },
      expect: () => [
        isA<CoffeeLoading>(),
        isA<CoffeeError>().having((e) => e.errorMessage, 'errorMessage',
            'Failed to fetch image: Exception: Failed to fetch image'),
      ],
    );
  });
}
