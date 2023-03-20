import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Feedback',
      home: FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int happyCount = 0;
  int neutralCount = 0;
  int unhappyCount = 0;

  void incrementCount(int index) {
    setState(() {
      if (index == 0) {
        happyCount++;
      } else if (index == 1) {
        neutralCount++;
      } else if (index == 2) {
        unhappyCount++;
      }
    });
  }

  void _showThankYouPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          backgroundColor: Colors.white,
          content: Text(
            'Thank you for your feedback!',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'How was the event?',
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _FeedbackButton(
                  icon: Icons.sentiment_satisfied_alt,
                  color: Colors.green,
                  onPressed: () {
                    incrementCount(0);
                    _showThankYouPopup(context);
                  },
                  context: context,
                ),
                _FeedbackButton(
                  icon: Icons.sentiment_neutral,
                  color: Color.fromARGB(255, 207, 190, 32),
                  onPressed: () {
                    incrementCount(1);
                    _showThankYouPopup(context);
                  },
                  context: context,
                ),
                _FeedbackButton(
                  icon: Icons.sentiment_dissatisfied,
                  color: Colors.red,
                  onPressed: () {
                    incrementCount(2);
                    _showThankYouPopup(context);
                  },
                  context: context,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Text(
            'Happy: $happyCount, Neutral: $neutralCount, Unhappy: $unhappyCount',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;
  final BuildContext context;

  const _FeedbackButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.context,
  }) : super(key: key);

  @override
  __FeedbackButtonState createState() => __FeedbackButtonState();
}

class __FeedbackButtonState extends State<_FeedbackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void _showThankYouPopup() {
    showDialog(
      context: widget.context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          backgroundColor: Colors.white,
          content: Text(
            'Thank you for your feedback!',
            style: TextStyle(fontSize: 32, color: Colors.black),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.9).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: () {
        widget.onPressed();
        _showThankYouPopup();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
