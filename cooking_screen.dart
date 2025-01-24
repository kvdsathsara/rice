        import 'package:flutter/material.dart';
        import 'dart:async';

        class CookingScreen extends StatefulWidget {   
          final String riceType;
          final List<String> ingredients;
          final String spiceLevel;

          const CookingScreen({
            required this.riceType,
            required this.ingredients,
            required this.spiceLevel,
            });

          @override
          _CookingScreenState createState() => _CookingScreenState();
        }

        class _CookingScreenState extends State<CookingScreen> {
          double progress = 0.0;
          late Timer timer;
          String currentStep = 'Preparing Rice...';

          @override
          void initState() {
            super.initState();
            startCooking();
          }

          void startCooking() {
            const totalTime = 20; // --Total cooking time in seconds
            const updateInterval = 1; // --Update cooking 

            timer = Timer.periodic(const Duration(seconds: updateInterval), (timer) {
              setState(() {
                progress += 1.0 / totalTime;

                if (progress <= 0.3) {
                  currentStep = 'Preparing Rice...';
                } else if (progress <= 0.6) {
                  currentStep = 'Adding Ingredients...';
                } else if (progress <= 0.9) {
                  currentStep = 'Frying Rice...';
                } else {
                  currentStep = 'Finishing Up...';
                }

                if (progress >= 1.0) {
                  timer.cancel();
                  showCompletionDialog();
                }
              });
            });
          }

          void showCompletionDialog() {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text(
                    '🍚 Cooking Complete! 🎉',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 22,
                    ),
                  ),
                  content: const Text(
                    'Your fried rice is ready to serve.🍴',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 18, color: Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                  ],
                );
              },
            );
          }

          @override
          void dispose() {
            timer.cancel();
            super.dispose();
          }

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Cooking in Progress 🍳',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.orangeAccent,
                centerTitle: true,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade100, Colors.orange.shade300],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Current Step
                        Text(
                          currentStep,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Circular Progress Indicator
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 20,
                          color: Colors.deepOrange,
                          backgroundColor: Colors.orange.shade200,
                        ),
                        const SizedBox(height: 32),
                        // Recipe Details
                        Text(
                          'Recipe Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Card with Details
                        Card(
                          elevation: 8,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                detailRow('🍚 Rice Type:', widget.riceType, Colors.green),
                                const SizedBox(height: 8),
                                detailRow('🥗 Ingredients:', widget.ingredients.join(', '), Colors.orange),
                                const SizedBox(height: 8),
                                detailRow('🌶 Spice Level:', widget.spiceLevel, Colors.red),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          Widget detailRow(String label, String value, Color color) {
            return RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: ' $value',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }
        }
