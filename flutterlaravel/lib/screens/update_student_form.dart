import 'package:flutter/material.dart';
import 'package:flutterlaravel/models/students.dart';

class UpdateStudentForm extends StatefulWidget {
  static const routeName = '/update-student-form';

  @override
  _UpdateStudentFormState createState() => _UpdateStudentFormState();
}

class _UpdateStudentFormState extends State<UpdateStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Students studentService = Students();

  void updateStudent(int id, Map<String, dynamic> updatedData) {
    studentService.updateStudent(id, updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student data updated successfully'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update student data'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final studentId = routeArgs?['studentId'] as int? ?? 0;
    final initialData = routeArgs?['initialData'] as Map<String, dynamic>?;

    if (initialData != null) {
      _nameController.text = initialData['name'] ?? '';
      _courseController.text = initialData['course'] ?? '';
      _emailController.text = initialData['email'] ?? '';
      _phoneController.text = initialData['phone'] ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedData = {
                      'name': _nameController.text,
                      'course': _courseController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                    };

                    updateStudent(studentId, updatedData);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
