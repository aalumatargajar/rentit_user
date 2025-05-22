import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit_user/src/common/const/global_variable.dart';
import 'package:rentit_user/src/common/model/booking_model.dart';
import 'package:rentit_user/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit_user/src/common/widgets/custom_widgets.dart';
import 'package:rentit_user/src/features/booking/booking_provider.dart';
import 'package:rentit_user/src/features/bottom_nav/bottom_navbar_provider.dart';

class BookingPickupDialog extends StatefulWidget {
  final BookingModel bookingModel;
  const BookingPickupDialog({super.key, required this.bookingModel});

  @override
  State<BookingPickupDialog> createState() => _BookingPickupDialogState();
}

class _BookingPickupDialogState extends State<BookingPickupDialog> {
  final List<String> locationsList = [
    'Mohal Chowk Bypass',
    'Bahawali Chowk',
    'City Chowk',
    'Model Town Gate',
    'Minchanabad Chowk',
  ];

  String selectedLocation = 'Mohal Chowk Bypass';
  void onChanged(String? value) {
    setState(() {
      selectedLocation = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Booking Confirmation"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomWidgets.customNameAndDropDownMenu2(
            title: "Pickup Location:*",
            selectedItem: selectedLocation,
            itemsList: locationsList,
            onChanged: (p0) {
              onChanged(p0.toString());
            },
            context: context,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomElevatedButton(
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
              borderSide: BorderSide(
                color: colorScheme(context).primary,
                width: 1,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Cancel",
              width: 80,
              height: 40,
              textSize: 12,
            ),
            const SizedBox(width: 10),
            CustomElevatedButton(
              width: 80,
              height: 40,
              onPressed: () {
                final provider = Provider.of<BookingProvider>(
                  context,
                  listen: false,
                );
                provider.addBooking(
                  context: context,
                  pickupLocation: selectedLocation,
                  booking: widget.bookingModel,
                  onSuccess: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    final bottomNavProvider = Provider.of<BottomNavbarProvider>(
                      context,
                      listen: false,
                    );
                    bottomNavProvider.changeIndex(index: 1);
                  },
                );
              },
              textSize: 12,
              text: "Confirm",
            ),
          ],
        ),
      ],
    );
  }
}
