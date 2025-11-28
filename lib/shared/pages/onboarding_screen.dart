import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: const [
              _OnboardPage(
                title: "Manage Students Easily",
                subtitle:
                    "Track student profiles, classes, and academic history with ease.",
                animation: "assets/animations/student.json",
              ),
              _OnboardPage(
                title: "Attendance Tracking",
                subtitle:
                    "Mark attendance fast and monitor daily classroom performance.",
                animation: "assets/animations/attendance.json",
              ),
              _OnboardPage(
                title: "Grades & Performance",
                subtitle:
                    "Record grades and generate student performance reports instantly.",
                animation: "assets/animations/grades.json",
              ),
            ],
          ),

          /// Indicator + Buttons
          Positioned(
            bottom: 50,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 20),

                // Main Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(isLastPage ? "Get Started" : "Next"),
                ),

                // Skip button
                if (!isLastPage)
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text("Skip"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String animation;

  const _OnboardPage({
    required this.title,
    required this.subtitle,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, height: 260),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
