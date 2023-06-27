import 'package:flutter/material.dart';
import 'package:flutterlaravel/models/students.dart';

class AddStudentForm extends StatefulWidget {
  static const routeName = '/add-student-form';

  @override
  _AddStudentFormState createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Students studentService = Students();

  void addStudent() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final course = _courseController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;

      studentService.addStudent(name, course, email, phone).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added successfully'),
          ),
        );
        Navigator.pop(context, true); // Return a value indicating success
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add student'),
          ),
        );
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
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
                  if (value == null || value.isEmpty ) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: addStudent,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
