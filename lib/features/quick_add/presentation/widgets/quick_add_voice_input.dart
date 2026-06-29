import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef VoiceResultCallback = void Function(int amountPaise, String? merchant);

class QuickAddVoiceButton extends StatefulWidget {
  const QuickAddVoiceButton({required this.onResult, super.key});

  final VoiceResultCallback onResult;

  @override
  State<QuickAddVoiceButton> createState() => _QuickAddVoiceButtonState();
}

class _QuickAddVoiceButtonState extends State<QuickAddVoiceButton> {
  final _speech = SpeechToText();
  bool _listening = false;
  bool _available = false;
  bool _initializing = false;

  Future<void> _initSpeech() async {
    if (_available || _initializing) return;

    setState(() => _initializing = true);
    try {
      _available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _listening = false);
          }
        },
        onError: (_) {
          if (mounted) setState(() => _listening = false);
        },
      );
    } catch (_) {
      _available = false;
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _toggleListen() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }

    if (_initializing) return;

    final micGranted = await _ensureMicPermission();
    if (!micGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for voice input'),
        ),
      );
      return;
    }

    if (!_available) {
      await _initSpeech();
    }

    if (!_available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice input not available on this device'),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        final parsed = parseVoiceExpense(result.recognizedWords);
        widget.onResult(parsed.$1, parsed.$2);
        if (result.finalResult) {
          _speech.stop();
          if (mounted) setState(() => _listening = false);
        }
      },
      listenFor: const Duration(seconds: 8),
      pauseFor: const Duration(seconds: 2),
      localeId: 'en_IN',
    );
  }

  Future<bool> _ensureMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) return true;
    status = await Permission.microphone.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton.tonalIcon(
        onPressed: _initializing ? null : _toggleListen,
        icon: Icon(_listening ? Icons.mic : Icons.mic_none),
        label: Text(
          _initializing
              ? 'Starting…'
              : _listening
                  ? 'Listening…'
                  : 'Voice',
        ),
      ),
    );
  }
}

(int amountPaise, String? merchant) parseVoiceExpense(String speech) {
  final lower = speech.toLowerCase();
  int? rupees;

  final digitMatch = RegExp(r'(\d{1,7})').firstMatch(lower);
  if (digitMatch != null) {
    rupees = int.tryParse(digitMatch.group(1)!);
  }

  if (rupees == null) {
    final words = <String, int>{
      'one thousand': 1000,
      'five hundred': 500,
      'three hundred': 300,
      'two hundred': 200,
      'one hundred': 100,
      'thousand': 1000,
      'hundred': 100,
      'fifty': 50,
    };
    final sorted = words.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in sorted) {
      if (lower.contains(key)) {
        rupees = words[key];
        break;
      }
    }
  }

  String? merchant;
  final cleaned = lower
      .replaceAll(RegExp(r'\d+'), '')
      .replaceAll(RegExp(r'\b(rupees?|rs|for|on|at|spent|paid)\b'), ' ')
      .trim();
  if (cleaned.length > 2) {
    merchant = cleaned
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .take(3)
        .join(' ');
    if (merchant.isEmpty) {
      merchant = null;
    } else {
      merchant = merchant[0].toUpperCase() + merchant.substring(1);
    }
  }

  return ((rupees ?? 0) * 100, merchant);
}
