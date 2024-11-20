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
  var _courses= <int, int>{};

  double _initialGPA = 0;
  int _initialCredits = 0;

  void updateText() {
    setState(() {
      if(addCourse()){
          _text = calculateGPA(_initialGPA, _initialCredits, _courses).toString();
          print("Executed");
      }else{
        _text = "Please fill the required fields";
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

  bool addCourse(){
    if(_credits == -1 || _grade == -1){
      return false;
    }else{
      _courses.addAll(<int, int>{_credits:_grade});
      return true;
    }
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
              ElevatedButton(onPressed: (){updateText();}, child: Text('Add Course')),
              const SizedBox(height: 20.0),
              Text('GPA: $_text', style: const TextStyle(fontSize: 18.0)),
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


double calculateGPA(double initialGpa, int initialCredits, Map<int, int> courses){
  double totalQualityPoints = initialGpa * initialCredits;
  int totalCredits = initialCredits;

  courses.forEach((credits,grade){
    double qualityPoints = 1 + (grade - 60) * 0.1;

    totalQualityPoints += qualityPoints * credits;
    totalCredits += credits;
  });

  // Calculate the new GPA
  double currentGpa = totalQualityPoints / totalCredits;

  print(initialGpa);
  print(initialCredits);
  print(currentGpa);

  return currentGpa;
}
