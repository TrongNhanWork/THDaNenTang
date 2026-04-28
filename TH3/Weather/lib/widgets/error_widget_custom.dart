import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorWidgetCustom({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOffline = message.contains('Không có kết nối Internet');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOffline ? Icons.wifi_off : Icons.error_outline,
              color: isOffline ? Colors.grey : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              isOffline ? 'Không có kết nối Internet' : 'Oops! Something went wrong.',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isOffline ? 'Vui lòng kiểm tra WiFi hoặc dữ liệu di động' : message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
