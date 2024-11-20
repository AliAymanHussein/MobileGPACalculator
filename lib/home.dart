import 'dart:ffi';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = '';
  int _credits = -1;
  int _grade = -1;
  Map<int, Map<String, int>> _courses = {};


  double _initialGPA = 0;
  int _initialCredits = 0;

  void updateText() {
    setState(() {
      if(addCourse()){
          _text = "GPA: ${calculateGPA(_initialGPA, _initialCredits, _courses)}";
          print("Executed");
      }else{
        _text = "Invalid Parameters, please check your entered values and try again.";
        print("notExecuted");
      }
    });
  }

  void updateCredits(String text){
    setState(() {
      if(text == ''){
        _credits = -1;
      }else{
      _credits = int.parse(text);
      }
    });
  }

  void updateGrade(String text){
    setState(() {
      if(text == ''){
        _grade = -1;
      }else{
        _grade = int.parse(text);
      }
    });
  }

  void updateInitialGPA(String text){
    setState(() {
      if(text == ''){
        _initialGPA = 0;
      }else{
      _initialGPA = double.parse(text);
      }
    });
  }

  void updateInitialCredits(String text){
    setState(() {
      if(text == ''){
        _initialCredits = 0;
      }else{
        _initialCredits = int.parse(text);
      }
    });
  }

  bool addCourse() {
    if (_credits == -1 || _grade == -1 || _grade > 100) {
      return false;
    } else {
      int courseId = _courses.length + 1; // Unique course ID
      _courses[courseId] = {'credits': _credits, 'grade': _grade};
      return true;
    }
  }

  void deleteCourse(int courseId) {
    setState(() {
      _courses.remove(courseId);
      _text = "GPA: ${calculateGPA(_initialGPA, _initialCredits, _courses)}";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GPA Calculator'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20.0,),
              MyTextField(hint: "Enter Course Credits", f: updateCredits),
              const SizedBox(height: 20.0,),
              MyTextField(hint: "Enter Course Grade", f: updateGrade),
              const SizedBox(height: 20.0,),
              MyTextField(hint: "Enter Initial GPA (optional)", f: updateInitialGPA),
              const SizedBox(height: 20.0,),
              MyTextField(hint: "Enter Initial Credits (optional)", f: updateInitialCredits),
              const SizedBox(height: 20.0,),
              ElevatedButton(onPressed: (){updateText();}, child: Text('Add Course and Calculate GPA')),
              const SizedBox(height: 20.0),
              Text(_text, style: const TextStyle(fontSize: 18.0)),

              Expanded(
                child: ListView.builder(
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    int courseId = _courses.keys.elementAt(index);
                    var course = _courses[courseId]!;
                    int credits = course['credits']!;
                    int grade = course['grade']!;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: ListTile(
                        title: Text('Course $courseId'),
                        subtitle: Text('Credits: $credits, Grade: $grade'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteCourse(courseId); // Delete course
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),


            ],
          ),
        )
    );
  }
}





class MyTextField extends StatelessWidget {
  Function(String) f; // hold a variable function
  String hint; // holds the hintText of the TextField
  MyTextField({required this.hint, required this.f, super.key,});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 300.0, height: 50.0,
      child: TextField(
        style: const TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
            border: const OutlineInputBorder(), hintText: hint
        ),
        onChanged: (text) { f(text);}, // call the variable function
      ),
    );
  }
}


double calculateGPA(double initialGpa, int initialCredits, Map<int, Map<String, int>> courses) {
  double totalQualityPoints = initialGpa * initialCredits;
  int totalCredits = initialCredits;

  // Iterate over each course to calculate quality points
  courses.forEach((id, course) {
    int credits = course['credits']!;
    int grade = course['grade']!;

    double qualityPoints;

    // Check for grade below 60 (0 QPTs), between 60 and 90 (standard calculation), or 90 and above (4 QPTs)
    if (grade < 60) {
      qualityPoints = 0.0; // Grade below 60 results in 0 quality points
    } else if (grade >= 90) {
      qualityPoints = 4.0; // Grade 90 or above caps at 4 quality points
    } else {
      qualityPoints = 1 + (grade - 60) * 0.1; // Standard calculation for grades between 60 and 90
    }

    totalQualityPoints += qualityPoints * credits;
    totalCredits += credits;
  });

  return totalQualityPoints / totalCredits;
}


