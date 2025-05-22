import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:rentit_user/src/common/const/global_variable.dart';
import 'package:rentit_user/src/common/model/notification_model.dart';
import 'package:rentit_user/src/common/widgets/custom_back_button.dart';
import 'package:rentit_user/src/common/widgets/custom_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Query query() {
    return _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Notifications'),
      ),
      body: FirestorePagination(
        physics: BouncingScrollPhysics(),
        query: query(),
        limit: 5,
        isLive: true,
        bottomLoader: CustomWidgets.shimmerLoader(context: context, height: 60),
        initialLoader: CustomWidgets.shimmerLoader(
          context: context,
          height: 60,
        ),
        onEmpty: CustomWidgets.emptyWidget(
          context: context,
          title: "No Notification Found",
        ),
        separatorBuilder: (p0, p1) => SizedBox(height: 8),
        itemBuilder: (context, docs, index) {
          final data = docs[index].data() as Map<String, dynamic>;

          final notification = NotificationModel.fromJson(data);

          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme(context).outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder:
                //         (context) =>
                //             BookingDetailsScreen(bookingModel: booking),
                //   ),
                // );
              },
              child: ListTile(
                title: Text(
                  "Car booked by",
                  style: txtTheme(context).titleMedium,
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: txtTheme(context).bodyMedium,
                    children: [
                      const TextSpan(
                        text: "Pickup location: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: notification.pickupLocation),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
