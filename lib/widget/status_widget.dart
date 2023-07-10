import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';

///For the status of the quiz
class StatusWidget extends StatelessWidget {
  StatusWidget({
    Key? key,
    required this.onRefresh,
    required this.contentWidget,
    required this.status,
    this.errorText = 'Oops, something went wrong! Please Retry!',
    this.emptyText = 'No Question Found... Please Retry...',
  }) : super(key: key);

  final String? errorText;
  final String? emptyText;
  final QuizStatus status;
  final Function() onRefresh;
  final Widget Function(BuildContext context) contentWidget;

  @override
  Widget build(BuildContext context) {
    if (status == QuizStatus.display) {
      return contentWidget.call(context);
    } else if (status == QuizStatus.empty || status == QuizStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(status == QuizStatus.empty ? emptyText! : errorText!),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
