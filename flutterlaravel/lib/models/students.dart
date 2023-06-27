import 'dart:convert';
import 'package:http/http.dart' as http;

class Students {
  String baseUrl = 'http://10.0.2.2:8000/api/students';
  bool _isDeleting = false;
  List<dynamic> students = [];

  Future<List<dynamic>> getAllStudent() async {
  try {
    var response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['students'] != null && data['students'] is List<dynamic>) {
        return data['students'] as List<dynamic>;
      } else {
        throw Exception('Invalid response format: students not found');
      }
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Request Error: $e');
  }
}


  Future<void> updateStudent(int id, Map<String, dynamic> updatedData) async {
  try {
    var response = await http.put(Uri.parse('$baseUrl/$id'), body: updatedData);
    if (response.statusCode == 200) {
      print('Student data updated successfully');
    } else {
      throw Exception('Failed to update student data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Request Error: $e');
  }
}


  Future<bool> addStudent(
      String name, String course, String email, String phone) async {
    try {
      var studentData = {
        'name': name,
        'course': course,
        'email': email,
        'phone': phone,
      };

      var response = await http.post(Uri.parse(baseUrl), body: studentData);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        /*QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Transaction Completed Successfully!',
        );*/
        return true;
      } else {
        throw Exception('Failed to add student');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteStudent(int studentId) async {
    if (_isDeleting) {
      return false; // Return false if deletion is already in progress
    }

    try {
      _isDeleting = true; // Set the deleting flag to true
      final response = await http.delete(Uri.parse('$baseUrl/$studentId'));
      if (response.statusCode == 200) {
        print('Student deleted successfully');
        students.removeWhere((student) =>
            student['id'] ==
            studentId); // Remove the deleted student from the list
        return true; // Deletion successful
      } else if (response.statusCode == 404) {
        print('Student not found');
        return false; // Deletion failed due to student not found
      } else {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    } finally {
      _isDeleting = false; // Reset the deleting flag to false
    }
  }
}
