import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:hotspot/feature/user/auth/screen/user_login_screen.dart';
import 'package:hotspot/feature/user/landing/model/onboarding_model.dart';
import 'package:hotspot/go_route.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  PageController _controller = PageController();
  int _currentPage = 0;
  List<OnboardingModel> onboardingData = [];
  @override
  void initState() {
    loadOnboardingData();
    super.initState();
  }

  Future<void> loadOnboardingData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Onboarding")
        .orderBy("index", descending: true)
        .get();

    if (mounted) {
      setState(() {
        onboardingData = snapshot.docs
            .map((doc) => OnboardingModel.fromFirestore(doc))
            .toList();
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        vsync: this,
        behaviour: RacingLinesBehaviour(),
        child: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },

                itemBuilder: (context, index) {
                  final items = onboardingData[index];
                  return Column(
                    children: [
                      SizedBox(height: 50),
                      Lottie.network(
                        items.image,
                        height: 400,
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(height: 20),
                      Text(
                        items.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        items.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      //page indicator (dots showing currents page)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: _currentPage == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 85),
                      if (_currentPage == onboardingData.length - 1)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 50),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              NavigationHelper.push(context, UserLoginScreen());
                            },

                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
