// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../ViewModel/models/category.dart';
import '../../../ViewModel/models/question.dart';
import '../../../res/api_provider.dart';
import '../pages/error.dart';
import '../pages/quiz_page.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Category? category;

  const QuizOptionsDialog({Key? key, this.category}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? _noOfQuestions;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(
              widget.category!.name,
              style: Theme.of(context).textTheme.headline6!.copyWith(),
            ),
          ),
          const SizedBox(height: 10.0),
          const Text("Select Total Number of Questions"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 0.0),
                ActionChip(
                  label: const Text("10"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 10
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(10),
                ),
                ActionChip(
                  label: const Text("20"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 20
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: const Text("30"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 30
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: const Text("40"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 40
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: const Text("50"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 50
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          const Text("Select Difficulty"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 0.0),
                ActionChip(
                  label: const Text("Any"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == null
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty(null),
                ),
                ActionChip(
                  label: const Text("Easy"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "easy"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("easy"),
                ),
                ActionChip(
                  label: const Text("Medium"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "medium"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("medium"),
                ),
                ActionChip(
                  label: const Text("Hard"),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "hard"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("hard"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          processing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  child: const Text("Start Quiz"),
                  onPressed: _startQuiz,
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                      shadowColor: MaterialStateProperty.all(Colors.indigo)),
                ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String? s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<Question> questions =
          await getQuestions(widget.category!, _noOfQuestions, _difficulty);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const ErrorPage(
                  message:
                      "There are not enough questions in the category with the options you selected.",
                )));
        return;
      }
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: QuizPage(
            questions: questions,
            category: widget.category,
          ),
          withNavBar: false);
    } on SocketException catch (_) {
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: const ErrorPage(
            message:
                "Can't reach the servers, \n Please check your internet connection.",
          ),
          withNavBar: false);
    } catch (e) {
      print(e.toString());
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: const ErrorPage(
            message: "Unexpected error trying to connect to the API",
          ),
          withNavBar: false);
    }
    setState(() {
      processing = false;
    });
  }
}
