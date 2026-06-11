import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuizMaster());
}

List<Map<String, dynamic>> leaderboard = [];

class QuizMaster extends StatelessWidget {
  const QuizMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Master',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final TextEditingController controller =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz,
              size: 120,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 20),

            const Text(
              "Quiz Master",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter Username",
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(
                        username:
                        controller.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Start Quiz",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({
    super.key,
    required this.username,
  });

  final List<String> categories = const [
    "Science",
    "Movies",
    "Sports",
    "Technology",
    "History",
    "Programming",
    "Mixed Quiz"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Master"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const LeaderboardScreen(),
                ),
              );
            },
            icon: const Icon(Icons.leaderboard),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.purpleAccent
                ],
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Welcome, $username",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Choose a category and test your knowledge!",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(20),
              color: Colors.orange,
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb,
                    size: 40),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Fun Fact: Flutter apps use widgets for everything visible on screen!",
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              QuizScreen(
                                username:
                                username,
                                category:
                                categories[index],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            20),
                        gradient:
                        const LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.purple
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: [
                          const Icon(
                            Icons.quiz,
                            size: 45,
                          ),
                          const SizedBox(
                              height: 10),
                          Text(
                            categories[index],
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String category;
  final String username;

  const QuizScreen({
    super.key,
    required this.category,
    required this.username,
  });

  @override
  State<QuizScreen> createState() =>
      _QuizScreenState();
}

class _QuizScreenState
    extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  int streak = 0;

  int timeLeft = 15;

  late Timer timer;

  late List<Map<String, Object>>
  questions;

  final Map<String,
      List<Map<String, Object>>>
  categoryQuestions = {
    "Science": [
      {
        "question":
        "Who developed relativity?",
        "options": [
          "Newton",
          "Einstein",
          "Tesla",
          "Galileo"
        ],
        "answer": "Einstein",
      },
      {
        "question":
        "SI unit of Force?",
        "options": [
          "Watt",
          "Pascal",
          "Newton",
          "Joule"
        ],
        "answer": "Newton",
      },
      {
        "question":
        "Plants absorb which gas?",
        "options": [
          "Oxygen",
          "Hydrogen",
          "Carbon Dioxide",
          "Nitrogen"
        ],
        "answer":
        "Carbon Dioxide",
      },
    ],

    "Programming": [
      {
        "question":
        "FIFO is used in?",
        "options": [
          "Queue",
          "Stack",
          "Tree",
          "Graph"
        ],
        "answer": "Queue",
      },
      {
        "question":
        "Flutter uses which language?",
        "options": [
          "Java",
          "Python",
          "Dart",
          "C++"
        ],
        "answer": "Dart",
      },
      {
        "question":
        "Binary Search technique?",
        "options": [
          "Greedy",
          "Divide and Conquer",
          "DP",
          "Backtracking"
        ],
        "answer":
        "Divide and Conquer",
      },
    ],

    "Movies": [
      {
        "question":
        "Who directed Interstellar?",
        "options": [
          "Nolan",
          "Spielberg",
          "Cameron",
          "Russo"
        ],
        "answer": "Nolan",
      },
      {
        "question":
        "Actor of Iron Man?",
        "options": [
          "Tom Holland",
          "Chris Evans",
          "Robert Downey Jr",
          "Hemsworth"
        ],
        "answer":
        "Robert Downey Jr",
      },
      {
        "question":
        "Oscar awards are for?",
        "options": [
          "Science",
          "Movies",
          "Politics",
          "Sports"
        ],
        "answer": "Movies",
      },
    ],

    "Sports": [
      {
        "question":
        "Players in football team?",
        "options": [
          "9",
          "10",
          "11",
          "12"
        ],
        "answer": "11",
      },
      {
        "question":
        "Olympics held every?",
        "options": [
          "2",
          "3",
          "4",
          "5"
        ],
        "answer": "4",
      },
      {
        "question":
        "Messi belongs to?",
        "options": [
          "Football",
          "Cricket",
          "Tennis",
          "Golf"
        ],
        "answer": "Football",
      },
    ],

    "Technology": [
      {
        "question":
        "Company behind Android?",
        "options": [
          "Google",
          "Apple",
          "Meta",
          "Intel"
        ],
        "answer": "Google",
      },
      {
        "question":
        "RAM is which memory?",
        "options": [
          "Temporary",
          "Permanent",
          "Optical",
          "External"
        ],
        "answer": "Temporary",
      },
      {
        "question":
        "CPU stands for?",
        "options": [
          "Central Processing Unit",
          "Core Processing Unit",
          "Computer Unit",
          "Central Program Unit"
        ],
        "answer":
        "Central Processing Unit",
      },
    ],

    "History": [
      {
        "question":
        "India independence year?",
        "options": [
          "1945",
          "1946",
          "1947",
          "1950"
        ],
        "answer": "1947",
      },
      {
        "question":
        "Who built Taj Mahal?",
        "options": [
          "Akbar",
          "Shah Jahan",
          "Babur",
          "Ashoka"
        ],
        "answer": "Shah Jahan",
      },
      {
        "question":
        "First President of India?",
        "options": [
          "Gandhi",
          "Nehru",
          "Rajendra Prasad",
          "Patel"
        ],
        "answer":
        "Rajendra Prasad",
      },
    ],

    "Mixed Quiz": [
      {
        "question":
        "Largest ocean?",
        "options": [
          "Pacific",
          "Atlantic",
          "Indian",
          "Arctic"
        ],
        "answer": "Pacific",
      },
      {
        "question":
        "National bird of India?",
        "options": [
          "Crow",
          "Parrot",
          "Peacock",
          "Sparrow"
        ],
        "answer": "Peacock",
      },
      {
        "question":
        "Fastest land animal?",
        "options": [
          "Tiger",
          "Cheetah",
          "Dog",
          "Horse"
        ],
        "answer": "Cheetah",
      },
    ],
  };

  @override
  void initState() {
    super.initState();

    questions =
    categoryQuestions[
    widget.category]!;

    startTimer();
  }

  void startTimer() {
    timeLeft = 15;

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } else {
          timer.cancel();

          setState(() {
            currentQuestion++;
          });

          if (currentQuestion <
              questions.length) {
            startTimer();
          }
        }
      },
    );
  }

  void checkAnswer(String answer) {
    timer.cancel();

    bool correct =
        answer ==
            questions[currentQuestion]
            ["answer"];

    if (correct) {
      score++;
      streak++;
    } else {
      streak = 0;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          correct
              ? "Correct!"
              : "Wrong!",
        ),
      ),
    );

    setState(() {
      currentQuestion++;
    });

    if (currentQuestion <
        questions.length) {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >=
        questions.length) {
      leaderboard.add({
        "name": widget.username,
        "score": score,
      });

      return ResultScreen(
        username: widget.username,
        score: score,
        total: questions.length,
      );
    }

    final question =
    questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          Padding(
            padding:
            const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "Score: $score",
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value:
              (currentQuestion + 1) /
                  questions.length,
            ),

            const SizedBox(height: 20),

            Container(
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius:
                BorderRadius.circular(
                    15),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(width: 10),
                  Text(
                    "Time Left: $timeLeft",
                    style:
                    const TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Current Streak: $streak",
              style:
              const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 10,
              child: Padding(
                padding:
                const EdgeInsets.all(
                    20),
                child: Column(
                  children: [
                    Chip(
                      label:
                      const Text("Medium"),
                      backgroundColor:
                      Colors.orange,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      question["question"]
                      as String,
                      style:
                      const TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            ...(question["options"]
            as List<String>)
                .map(
                  (option) => Padding(
                padding:
                const EdgeInsets.only(
                    bottom: 15),
                child: ElevatedButton(
                  onPressed: () =>
                      checkAnswer(option),
                  child: Text(option),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String username;
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.username,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    double percentage =
        (score / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: Center(
        child: Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 120,
                color: Colors.amber,
              ),

              const SizedBox(height: 20),

              Text(
                "$username's Result",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Score: $score / $total",
                style:
                const TextStyle(fontSize: 24),
              ),

              const SizedBox(height: 10),

              Text(
                "Percentage: ${percentage.toStringAsFixed(1)}%",
                style:
                const TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon:
                const Icon(Icons.home),
                label:
                const Text("Home"),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HomeScreen(
                            username:
                            username,
                          ),
                    ),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderboardScreen
    extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    leaderboard.sort(
          (a, b) =>
          b["score"].compareTo(a["score"]),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
      ),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading:
              const Icon(Icons.person),
              title: Text(
                  leaderboard[index]["Name(s)"]),
              trailing: Text(
                "Score: ${leaderboard[index]["check ur scores!!git --version"]}",
              ),
            ),
          );
        },
      ),
    );
  }
}