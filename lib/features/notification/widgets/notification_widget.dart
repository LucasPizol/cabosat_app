import 'package:cabosat/features/home/widgets/invoice_tag.dart';
import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/models/notification_model.dart';
import 'package:cabosat/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  final Function(String) onSelected;
  final bool isSelected;

  const NotificationWidget({
    super.key,
    required this.notification,
    required this.onSelected,
    required this.isSelected,
  });

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: const Text('Deseja realmente excluir essa notificação?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<NotificationProvider>(context, listen: false)
                    .removeNotification(notification.id);
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Excluir'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer(
          builder: (context, NotificationProvider notificationProvider, child) {
        return ListTile(
          onTap: () {
            onSelected(notification.id);
            notificationProvider.markAsRead(notification);
          },
          onLongPress: () {
            _showDialog(context);
          },
          isThreeLine: isSelected,
          title: Text(notification.title),
          trailing: notification.isRead
              ? null
              : const InvoiceTag(status: InvoiceStatus.Vencido, text: 'Novo'),
          subtitle: isSelected
              ? Text(notification.body)
              : Text(
                  notification.body,
                  overflow: TextOverflow.ellipsis,
                ),
        );
      }),
    );
  }
}
