
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterlaravel/services/auth.dart';
import 'package:flutterlaravel/models/students.dart';
import 'package:flutterlaravel/screens/add_student_form.dart';
import 'package:flutterlaravel/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterlaravel/screens/update_student_form.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Students studentService = Students();
  final storage = FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    readToken(context);
  }

  void readToken(BuildContext context) async {
    String? token = await storage.read(key: 'token') as String?;
    if (token != null) {
      Provider.of<Auth>(context, listen: false).tryToken(token: token);
      print(token);
    } else {
      // Handle the case when the token is null
      print('Token is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Fetch the updated student data
                studentService.getAllStudent().then((updatedStudentData) {
                  setState(() {
                    // Update the student list with the fetched data
                    studentService.students = updatedStudentData;
                  });
                }).catchError((error) {
                  // Handle error, e.g., show an error message
                  print('Failed to fetch student data: $error');
                });
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStudentForm()),
                );
              },
              child: const Text('Add Student'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: studentService.getAllStudent(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Failed to load student data'));
                  } else if (snapshot.hasData) {
                    final studentList = snapshot.data!;
                    if (studentList.isEmpty) {
                      return const Center(child: Text('No students found'));
                    }
                    return ListView.builder(
                      itemCount: studentList.length,
                      itemBuilder: (context, index) {
                        final student = studentList[index];
                        return ListTile(
                          title: Text(
                            student['name'],
                            style: const TextStyle(fontSize: 15),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['course'],
                                style: const TextStyle(fontSize: 10),
                              ),
                              Text(
                                student['email'],
                                style: const TextStyle(fontSize: 10),
                              ),
                              Text(
                                student['phone'],
                                style: const TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    UpdateStudentForm.routeName,
                                    arguments: {
                                      'studentId': student['id'],
                                      'initialData': {
                                        'name': student['name'],
                                        'course': student['course'],
                                        'email': student['email'],
                                        'phone': student['phone'],
                                      },
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirmed = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: AlertDialog(
                                          title: const Text('Confirmation'),
                                          content: const Text(
                                              'Are you sure you want to delete?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Confirm'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  if (confirmed ?? false) {
                                    final success = await studentService
                                        .deleteStudent(student['id']);
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? 'Student deleted successfully'
                                            : 'Failed to delete student'),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (!auth.authenticated) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text("Login"),
                    leading: const Icon(Icons.login),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(auth.user.avatar),
                          radius: 30,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          auth.user.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          auth.user.email,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text("Logout"),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
