import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../Models/item.dart';

const String baseUrl = 'http://10.0.2.2:2426';

class ApiService {
  static final ApiService instance = ApiService._();

  final Dio dio = Dio();
  final Logger logger = Logger();

  ApiService._();

  Future<List<Item>> getProjects() async {
    logger.i('getProjects');

    try {
      final response = await dio.get('$baseUrl/projects');
      logger.i(response.data);

      return (response.data as List).map((e) => Item.fromJson(e)).toList();
    } catch (e) {
      logger.e('Error getting projects: $e');
      rethrow;
    }
  }

  Future<List<Item>> getProjectById(int id) async {
    logger.i('getProjectById');

    try {
      final response = await dio.get('$baseUrl/project/$id');
      logger.i(response.data);

      return (response.data as List).map((e) => Item.fromJson(e)).toList();
    } catch (e) {
      logger.e('Error getting project by id: $e');
      rethrow;
    }
  }

  Future<List<Item>> getInProgressProjects() async {
    logger.i('getInProgressItems');

    try {
      final response = await dio.get('$baseUrl/inProgress');
      logger.i(response.data);

      // final result = (response.data as List).map((e) => Item.fromJson(e)).toList();
      // result.sort((a, b) => a.price.compareTo(b.price) == 0 ? a.units.compareTo(b.units) : a.price.compareTo(b.price));
      //
      // return result.take(10).toList();

      return (response.data as List).map((e) => Item.fromJson(e)).toList();
    } catch (e) {
      logger.e('Error getting in progress items: $e');
      rethrow;
    }
  }

  Future<List<Item>> getTop5Projects() async {
    logger.i('getTop5');

    try {
      final response = await dio.get('$baseUrl/allProjects');
      logger.i(response.data);

      final result = (response.data as List).map((e) => Item.fromJson(e)).toList();
      result.sort((a, b) => a.status.compareTo(b.status) == 0 ? b.members.compareTo(a.members) : a.status.compareTo(b.status));

      return result.take(5).toList();

      //return (response.data as List).map((e) => Item.fromJson(e)).toList();
    } catch (e) {
      logger.e('Error getting top 5 items: $e');
      rethrow;
    }
  }


  Future<Item> addProject(Item item) async {
    logger.i('addProject: $item');

    try {
      final response = await dio.post('$baseUrl/project', data: item.toJsonWithoutId());
      logger.i(response.data);

      return Item.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        // Handle DioError
        if (e.response != null) {
          // The request was made, but the server responded with a non-200 status code
          print('DioError Response Data: ${e.response!.data}');
          print('DioError Response Status: ${e.response!.statusCode}');
          print('DioError Response Headers: ${e.response!.headers}');
        } else {
          // Something went wrong in setting up or sending the request
          print('DioError Message: ${e.message}');
        }
      }
      logger.e('Error adding project: $e');
      rethrow;
    }

  }

  // Future<void> deleteItem(int id) async {
  //   logger.i('deleteItem: $id');
  //
  //   try {
  //     final response = await dio.delete('$baseUrl/item/$id');
  //     logger.i(response.data);
  //
  //     if (response.statusCode != 200) {
  //       throw Exception(response.statusMessage);
  //     }
  //   } catch (e) {
  //     logger.e('Error deleting item: $e');
  //     rethrow;
  //   }
  // }

  Future<void> updateProjectEnroll(int id) async {
    logger.i('updatePrice: $id');

    try {
      final response = await dio.post('$baseUrl/enroll', data: {'id': id});
      logger.i(response.data);

      if (response.statusCode != 200) {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      logger.e('Error updating project members: $e');
      rethrow;
    }
  }
}
