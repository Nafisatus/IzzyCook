import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

/// Service untuk mengambil data resep dari TheMealDB.
class MealService {
  static const String _baseUrl =
      'https://www.themealdb.com/api/json/v1/1/search.php';

  /// Mencari resep berdasarkan nama. Mengembalikan list kosong jika tidak ada hasil.
  Future<List<Meal>> searchMeals(String query) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {'s': query});

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Server error (kode ${response.statusCode})');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = decoded['meals'];

      // Jika tidak ada hasil, API mengembalikan {"meals": null}
      if (meals == null) return [];

      return (meals as List)
          .map((item) => Meal.fromJson(item as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Koneksi terlalu lama, coba lagi');
    } on FormatException {
      throw Exception('Data dari server tidak dapat dibaca');
    }
  }
}