import 'package:flutter_test/flutter_test.dart';
import 'package:kaapi_picker/cubit/coffee_cubit.dart';
import 'package:kaapi_picker/cubit/coffee_state.dart';
import 'package:mocktail/mocktail.dart';

class _CoffeeCubitMock extends Mock implements CoffeeCubit {}

void main() {
  setUpAll(
    () {
      registerFallbackValue(Uri.parse('http://sample.com'));
    },
  );
  group("CoffeeCubit Unit tests", () {
    late CoffeeCubit mockCoffeeCubit;

    setUp(() {
      mockCoffeeCubit = _CoffeeCubitMock();
    });

    test(
        'CoffeeCubit emiting the CoffeeSuccessState when a coffee image url is fetched successfully.',
        () async {
      when(() => mockCoffeeCubit.fetchImageUrl()).thenAnswer(
        (_) async => 'https://coffee.alexflipnote.dev/WXMBNIFUN_U_coffee.jpg',
      );

      when(() => mockCoffeeCubit.state).thenReturn(CoffeeSuccess(
          'https://coffee.alexflipnote.dev/WXMBNIFUN_U_coffee.jpg'));

      await mockCoffeeCubit.fetchImageUrl();

      expect(mockCoffeeCubit.state, isA<CoffeeSuccess>());
    });

    test(
        'CoffeeCubit emiting the CofeeErrorState when fetching a coffee image url ',
        () async {
      final exception = Exception("Error fetching the coffee image");

      when(() => mockCoffeeCubit.fetchImageUrl()).thenAnswer(
        (_) async => 'Error fetching the coffee image',
      );

      when(() => mockCoffeeCubit.state)
          .thenReturn(CoffeeError(errorMessage: exception.toString()));

      await mockCoffeeCubit.fetchImageUrl();

      expect(mockCoffeeCubit.state, isA<CoffeeError>());
      expect((mockCoffeeCubit.state as CoffeeError).errorMessage,
          equals(exception.toString()));
    });
  });
}
