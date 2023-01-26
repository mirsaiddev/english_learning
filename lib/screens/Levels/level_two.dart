import 'dart:async';
import 'dart:convert';
import 'package:english_learning/extensions/duration.dart';
import 'package:english_learning/extensions/string.dart';
import 'package:english_learning/models/question_object.dart';
import 'package:english_learning/models/solved_question.dart';
import 'package:english_learning/screens/Success/succes_screen.dart';
import 'package:english_learning/services/hive_service.dart';
import 'package:english_learning/theme/my_colors.dart';
import 'package:english_learning/widgets/custom_cupertino_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LevelTwo extends StatefulWidget {
  const LevelTwo({Key? key}) : super(key: key);

  @override
  State<LevelTwo> createState() => _LevelTwoState();
}

class _LevelTwoState extends State<LevelTwo> {
  List<QuestionObject> questionObjectList = [];
  PageController pageController = PageController(initialPage: 0);
  int currentQuestion = 0;
  Timer? timer;
  Duration time = Duration.zero;
  bool quizCompleted = false;

  int correctAnswers() {
    int correctQuestions = solvedQuestions.where((element) => element.isCorrect).length;
    return correctQuestions;
  }

  int wrongAnswers() {
    int wrongQuestions = solvedQuestions.where((element) => !element.isCorrect).length;
    return wrongQuestions;
  }

  List<SolvedQuestion> solvedQuestions = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time = time + const Duration(seconds: 1);
      setState(() {});
    });
  }

  void cancelTimer() {
    if (timer != null) {
      timer?.cancel();
    }
  }

  void nextQuestion() {
    if (currentQuestion < questionObjectList.length - 1) {
      currentQuestion++;
      pageController.animateToPage(currentQuestion, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void setCurrentQuestion(int index) {
    currentQuestion = index;
    setState(() {});
  }

  void solveQuestion({required int questionNumber, required int answerIndex}) {
    solvedQuestions.add(SolvedQuestion(
      questionNumber: questionNumber,
      answerIndex: answerIndex,
      isCorrect: questionObjectList[questionNumber].correctAnswer.toAnswerIndex() == answerIndex,
    ));
    setState(() {});
  }

  Future<void> getData() async {
    final String response = await rootBundle.loadString('lib/assets/2.json');
    final data = await json.decode(response);
    var questionObjects = data['questionObjects'];
    questionObjectList = questionObjects.map<QuestionObject>((json) => QuestionObject.fromMap(json)).toList();
    startTimer();
    setState(() {});
  }

  Future<void> completeQuiz() async {
    quizCompleted = true;
    double successRate = (correctAnswers() / questionObjectList.length) * 100;
    if (successRate < 60) {
      await HiveService().setLevel(3);
      await Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
    }
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: currentQuestion == 0
          ? GestureDetector(
              onTap: () {
                nextQuestion();
              },
              child: Icon(Icons.arrow_forward_ios),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: MyColors.red),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          if (!quizCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: MyColors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              height: 300,
                              child: Column(
                                children: [
                                  Icon(Icons.warning),
                                  const Text(
                                    'Dikkat',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                  const Text('Bu testi bitirmek istediğinize emin misiniz?'),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(primary: MyColors.green),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Devam Et',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(primary: MyColors.red),
                                          onPressed: () async {
                                            completeQuiz();
                                            // StatisticsProvider statisticsProvider = Provider.of<StatisticsProvider>(context, listen: false);
                                            // statisticsProvider.getSolvedQuizs();
                                            Navigator.pop(context);

                                            showModalBottomSheet(
                                              context: context,
                                              enableDrag: false,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) => finishDialog(context),
                                            );
                                          },
                                          child: const Text(
                                            'Bitir',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                child: const Text(
                  'Testi Bitir',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            )
          else if (quizCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: MyColors.red,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: false,
                    backgroundColor: Colors.transparent,
                    builder: (context) => finishDialog(context),
                  );
                },
                child: const Text(
                  'Test Sonucu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            )
        ],
        title: Column(
          children: [
            Center(child: Text('Level 2', style: TextStyle(color: Colors.black))),
            Text(
              'English Learning',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timelapse),
                    const SizedBox(width: 6),
                    Text(time.visualize(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check),
                        const SizedBox(width: 6),
                        Text('${correctAnswers()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(Icons.close),
                        const SizedBox(width: 6),
                        Text('${wrongAnswers()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text('${currentQuestion + 1}/${questionObjectList.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setCurrentQuestion(index);
              },
              controller: pageController,
              itemCount: questionObjectList.length,
              itemBuilder: (context, index) {
                QuestionObject questionObject = questionObjectList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var content in questionObject.contents)
                                content.contains('img:')
                                    ? Center(
                                        child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Image.asset(
                                          'lib/assets/images/' + content.replaceFirst('img:', ''),
                                          height: 100,
                                        ),
                                      ))
                                    : Text(
                                        content,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: questionObject.contents.indexOf(content) == questionObject.questionBodyIndexIncontents
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                        ),
                                      )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var answer in questionObject.answers)
                                Builder(builder: (context) {
                                  int answerIndex = questionObject.answers.indexOf(answer);
                                  bool isSolved = solvedQuestions.any((element) => element.questionNumber == index);
                                  bool isCorrect = isSolved ? solvedQuestions.where((element) => element.questionNumber == index).first.isCorrect : false;
                                  int correctAnswerIndex = questionObject.correctAnswer.toAnswerIndex();
                                  int myAnswerIndex = isSolved ? solvedQuestions.where((element) => element.questionNumber == index).first.answerIndex : -1;

                                  Color cardColor;
                                  if (isCorrect) {
                                    cardColor = correctAnswerIndex == answerIndex ? MyColors.green : Theme.of(context).colorScheme.onPrimaryContainer;
                                  } else {
                                    cardColor = myAnswerIndex == answerIndex ? MyColors.red : Theme.of(context).colorScheme.onPrimaryContainer;
                                  }
                                  if (isSolved) {
                                    cardColor = correctAnswerIndex == answerIndex ? MyColors.green : cardColor;
                                  } else {
                                    cardColor = Theme.of(context).colorScheme.onPrimaryContainer;
                                  }
                                  Color textColor;
                                  if (cardColor != Theme.of(context).colorScheme.onPrimaryContainer) {
                                    textColor = Colors.white;
                                  } else {
                                    textColor = Colors.black;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (!isSolved && !quizCompleted) {
                                        solveQuestion(questionNumber: index, answerIndex: answerIndex);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: cardColor,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      width: double.infinity,
                                      child: Builder(builder: (context) {
                                        if (answer.contains('img:')) {
                                          return Image.network(
                                            answer.replaceAll('img:', ''),
                                            height: 50,
                                          );
                                        }
                                        return Text(
                                          answer,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
                                        );
                                      }),
                                    ),
                                  );
                                }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CustomCupertinoBottomSheet finishDialog(BuildContext context) {
    return CustomCupertinoBottomSheet(
      leading: const SizedBox(width: 40),
      title: 'Test Sonucu',
      trailing: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.close,
          color: Colors.grey,
        ),
      ),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.book),
                      const SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Level 1',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: Row(
                  children: [
                    TestResultWidget(
                      text: 'Geçen Süre',
                      value: time.visualize(),
                      color: MyColors.purpleLight,
                      icon: (Icons.timelapse),
                      image: '',
                    ),
                    const SizedBox(width: 16),
                    TestResultWidget(
                      text: 'Başarı Oranı',
                      value: '%${(correctAnswers() / questionObjectList.length * 100).toStringAsFixed(2)}',
                      color: MyColors.orange,
                      icon: Icons.timelapse,
                      image: '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: Row(
                  children: [
                    TestResultWidget(
                      text: 'Doğru Sayısı',
                      value: correctAnswers().toString(),
                      color: MyColors.green,
                      icon: Icons.check,
                      whiteIcon: false,
                      image: '',
                    ),
                    const SizedBox(width: 16),
                    TestResultWidget(
                      text: 'Yanlış Sayısı',
                      value: wrongAnswers().toString(),
                      color: MyColors.red,
                      icon: (Icons.close),
                      whiteIcon: false,
                      image: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomLeading: const SizedBox(width: 40),
      bottomTrailing: const SizedBox(width: 40),
    );
  }
}

class TestResultWidget extends StatelessWidget {
  const TestResultWidget({
    Key? key,
    required this.text,
    required this.value,
    required this.image,
    required this.color,
    required this.icon,
    this.whiteIcon = true,
  }) : super(key: key);

  final String text;
  final String value;
  final String image;
  final IconData icon;
  final Color color;
  final bool whiteIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          // image: DecorationImage(
          //   image: AssetImage(image),
          // ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: whiteIcon ? Colors.white : Colors.black,
            ),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
