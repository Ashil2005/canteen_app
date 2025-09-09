import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FeedbackPage extends StatefulWidget {
  final String? orderId; // optional: show which order is being rated
  const FeedbackPage({super.key, this.orderId});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 4.0;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks for your feedback!')),
    );
    Navigator.pop(context, {
      'rating': _rating,
      'comment': _ctrl.text.trim(),
      'orderId': widget.orderId,
    });
  }

  Widget _stars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < _rating.round();
        return IconButton(
          onPressed: () => setState(() => _rating = (i + 1).toDouble()),
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: AppColors.primary,
            size: 32,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.orderId != null)
              Text('Order: ${widget.orderId}',
                  style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            const Text('Rate your experience',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: AppColors.textColor)),
            const SizedBox(height: 8),
            _stars(),
            const SizedBox(height: 8),
            Text('$_rating / 5',
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            TextField(
              controller: _ctrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your feedback (optional)',
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
