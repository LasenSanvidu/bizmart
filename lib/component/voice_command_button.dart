// voice_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceButton extends StatefulWidget {
  final Function(String) onTextRecognized;
  final double initialX;
  final double initialY;

  const VoiceButton({
    Key? key,
    required this.onTextRecognized,
    this.initialX = 320.0,
    this.initialY = 550.0,
  }) : super(key: key);

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  double _voiceButtonX = 320.0;
  double _voiceButtonY = 550.0;

  @override
  void initState() {
    super.initState();
    _voiceButtonX = widget.initialX;
    _voiceButtonY = widget.initialY;
    _initSpeech();
  }

  // voice functions
  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      print("Speech recognition not available");
    }
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false; // Reset back to default state
        });
      }
    });

    await _speech.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          widget.onTextRecognized(result.recognizedWords);
        }
        if (mounted) {
          setState(() {});
        }
      },
      localeId: "en_US",
    );
  }

  void _stopListening() {
    _speech.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _voiceButtonX,
      top: _voiceButtonY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            // Calculate new positions
            double newX = _voiceButtonX + details.delta.dx;
            double newY = _voiceButtonY + details.delta.dy;

            // Get screen dimensions
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final buttonSize = _isListening ? 70.0 : 60.0;

            // Constrain X position
            if (newX < 0) {
              newX = 0;
            } else if (newX > screenWidth - buttonSize) {
              newX = screenWidth - buttonSize;
            }

            // Constrain Y position
            if (newY < 0) {
              newY = 0;
            } else if (newY > screenHeight - buttonSize - 163) {
              newY = screenHeight - buttonSize - 163;
            }

            _voiceButtonX = newX;
            _voiceButtonY = newY;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isListening ? 70 : 60,
          width: _isListening ? 70 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isListening
                ? LinearGradient(
                    colors: [Colors.green, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey[900]!, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: [
              if (_isListening)
                BoxShadow(
                  color: Colors.green.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isListening) // Pulsating effect when listening
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1, end: 1.3),
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    onEnd: () {
                      if (mounted) {
                        setState(() {}); // Restart animation
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              IconButton(
                iconSize: 32,
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _isListening ? _stopListening() : _startListening();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
