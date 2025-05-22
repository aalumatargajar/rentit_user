import 'package:flutter/material.dart';
import 'package:rentit_user/src/common/const/global_variable.dart';
import 'package:rentit_user/src/common/widgets/custom_back_button.dart';

class TermsPolicyScreen extends StatefulWidget {
  const TermsPolicyScreen({super.key});

  @override
  State<TermsPolicyScreen> createState() => _TermsPolicyScreenState();
}

class _TermsPolicyScreenState extends State<TermsPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Terms & Policy"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. Acceptance of Terms", style: txtTheme(context).titleSmall),
            Text(
              "By accessing or using the RentIt app, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree, please do not use the app.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("2. Eligibility", style: txtTheme(context).titleSmall),
            Text(
              "You must be at least 18 years old and possess a valid driver’s license to rent a vehicle through RentIt.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text(
              "3. User Responsibilities",
              style: txtTheme(context).titleSmall,
            ),
            Text(
              "Users must provide accurate, current, and complete information. You are responsible for maintaining the confidentiality of your account. Users must comply with all applicable traffic laws and rental terms.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text(
              "4. Booking and Payments",
              style: txtTheme(context).titleSmall,
            ),
            Text(
              "All vehicle rentals must be booked through the app. Payments are processed securely via integrated payment gateways. Cancellations and refunds are subject to the cancellation policy of individual car owners or agencies.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("5. Vehicle Use", style: txtTheme(context).titleSmall),
            Text(
              "Rented vehicles must be used responsibly and returned in the same condition. Users must not engage in illegal activities using the rented vehicles. Fuel, tolls, and traffic violations are the renter's responsibility.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text(
              "6. Insurance and Liability",
              style: txtTheme(context).titleSmall,
            ),
            Text(
              "Users may be required to provide proof of insurance or purchase coverage via RentIt. RentIt is not liable for accidents, theft, or damage during the rental period.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text(
              "7. Prohibited Activities",
              style: txtTheme(context).titleSmall,
            ),
            Text(
              "Unauthorized subleasing or transfer of rented vehicles. Misuse, abuse, or damage to the vehicle. Use of RentIt for commercial purposes without consent.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("8. Termination", style: txtTheme(context).titleSmall),
            Text(
              "RentIt reserves the right to suspend or terminate your account for violations of these terms or misuse of the platform.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("Changes to Terms", style: txtTheme(context).titleSmall),
            Text(
              "RentIt may modify these terms at any time. Continued use after changes indicates acceptance.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
