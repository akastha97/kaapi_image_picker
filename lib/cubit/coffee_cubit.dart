import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'coffee_state.dart';

/// Cubit to handle the network calls for Coffee
class CoffeeCubit extends Cubit<CoffeeState> {
  final http.Client client;

  CoffeeCubit({required this.client}) : super(CoffeeInitial());

  /// Method to fetch the coffee image
  Future<void> fetchImageUrl() async {
    try {
      emit(CoffeeLoading());
      final response = await client
          .get(Uri.parse("https://coffee.alexflipnote.dev/random.json"));
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        emit(CoffeeSuccess(responseBody['file']));
      } else {
        emit(CoffeeError(
            errorMessage:
                "Failed to fetch the coffee image due to non-200 status code."));
      }
    } catch (e) {
      emit(CoffeeError(errorMessage: "Failed to fetch image: ${e.toString()}"));
    }
  }
}
