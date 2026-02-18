import 'package:flutter/material.dart';
import 'package:kobac/shared/pages/home_screen.dart';
import 'package:kobac/shared/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  final List<Map<String, String>> pages = [
    {
      "title": "Manage Schools",
      "subtitle":
          "Kormeeri hawlaha dugsigaaga — meel kasta, wakhti kasta, adigoo adeegsanaya Kobac",
      "img": "assets/animations/onboarding_1.png",
    },
    {
      "title": "Track Attendance",
      "subtitle":
          "Si fudud u hel ogeysiisyada dugsiga iyo dhacdooyinka soo socda.",
      "img": "assets/animations/onboarding_2.png",
    },
    {
      "title": "Daily Snapshot",
      "subtitle":
          "Ku sii diyaar garoow maalin waxbarasho wanaagsan adigoo haysta xogta saxda ah.",
      "img": "assets/animations/onboarding_3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [
            /// PAGEVIEW
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == pages.length - 1;
                });
              },
              itemBuilder: (_, index) {
                final page = pages[index];

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(page["img"]!, height: 260),

                      const SizedBox(height: 40),
                      Text(
                        page["title"]!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),
                      Text(
                        page["subtitle"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),

            /// INDICATOR + BUTTONS
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  /// Smooth Page Indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: const ExpandingDotsEffect(
                      expansionFactor: 4,
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Color(0xFFF04D07),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// SKIP
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('is_first_launch', false);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),

                        /// NEXT or GET STARTED
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF04D07),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('is_first_launch', false);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            isLastPage ? "Get Started" : "Next",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy home screen
