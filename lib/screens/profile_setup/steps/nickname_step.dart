import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/auth_field.dart';

/// Step 1: "What should we call you?" — a headline plus a single text field,
/// reusing the existing AuthField styling from the signup screen.
class NicknameStep extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const NicknameStep({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<NicknameStep> createState() => _NicknameStepState();
}

class _NicknameStepState extends State<NicknameStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'What should we\ncall you?',
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 28.h),
        AuthField(
          controller: _controller,
          icon: const Icon(Icons.badge_outlined),
          hintText: 'Nickname',
        ),
      ],
    );
  }
}
