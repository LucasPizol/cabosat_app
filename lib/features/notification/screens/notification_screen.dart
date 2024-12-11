import 'package:cabosat/features/home/widgets/blanks_slate.dart';
import 'package:cabosat/features/notification/widgets/notification_widget.dart';
import 'package:cabosat/models/notification_model.dart';
import 'package:cabosat/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<String> _selectedIds = [];

  void _onSelected(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }

    setState(() {});
  }

  bool _isSelected(String id) {
    return _selectedIds.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 84, 20, 143),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Image.asset(
          'assets/images/cabosat-logo.png',
          width: 100,
        ),
      ),
      body: Consumer(
          builder: (context, NotificationProvider notification, child) {
        if (notification.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (notification.notifications.isEmpty) {
          return const BlanksSlate();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: notification.notifications.length,
          itemBuilder: (context, index) {
            NotificationModel thisNotification =
                notification.notifications[index];

            bool shouldRenderDate = index == 0 ||
                thisNotification.recievedAt.day !=
                    notification.notifications[index - 1].recievedAt.day;

            if (shouldRenderDate) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      "${thisNotification.recievedAt.day.toString().padLeft(2, '0')}/${thisNotification.recievedAt.month.toString().padLeft(2, '0')}/${thisNotification.recievedAt.year}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 84, 20, 143)),
                    ),
                  ),
                  NotificationWidget(
                    notification: thisNotification,
                    onSelected: _onSelected,
                    isSelected: _isSelected(thisNotification.id),
                  ),
                ],
              );
            }

            return NotificationWidget(
              notification: thisNotification,
              onSelected: _onSelected,
              isSelected: _isSelected(thisNotification.id),
            );
          },
        );
      }),
    );
  }
}
