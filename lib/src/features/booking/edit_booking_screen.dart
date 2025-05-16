import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentit_user/src/common/const/global_variable.dart';
import 'package:rentit_user/src/common/model/booking_model.dart';
import 'package:rentit_user/src/common/model/car_model.dart';
import 'package:rentit_user/src/common/utils/cities_list.dart';
import 'package:rentit_user/src/common/widgets/custom_back_button.dart';
import 'package:rentit_user/src/common/widgets/custom_textformfield.dart';
import 'package:rentit_user/src/features/booking/booking_provider.dart';
import 'package:rentit_user/src/features/bottom_nav/bottom_navbar_provider.dart';
import 'package:rentit_user/src/features/car/car_provider.dart';
import 'package:shimmer/shimmer.dart';

class EditBookingScreen extends StatefulWidget {
  final BookingModel bookingModel;
  const EditBookingScreen({super.key, required this.bookingModel});
  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  TextEditingController startLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  final now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double totalPrice = 0.0;
  int totalDays = 0;

  final List<String> citiesList = CitiesList.citiesList;
  String? selectedCity;

  CarModel? carModel;

  @override
  void initState() {
    super.initState();
    startDate = widget.bookingModel.startDate;
    endDate = widget.bookingModel.endDate;
    totalDays = endDate.difference(startDate).inDays + 1;
    carModel = getCarModel();
    totalPrice = totalDays * carModel!.pricePerDay;
    startLocationController.text = "Bahawal Nagar";
    selectedCity = widget.bookingModel.destination;
  }

  CarModel getCarModel() {
    final provider = Provider.of<CarProvider>(context, listen: false);
    return provider.carList.firstWhere(
      (car) => car.id == widget.bookingModel.carId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onTap: () => Navigator.of(context).pop()),
        title: Text("Edit Booking"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: carModel!.imageUrls.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      int realIndex,
                    ) {
                      final imageUrl = carModel!.imageUrls[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: colorScheme(context).outlineVariant,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,

                            placeholder:
                                (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.grey[300]),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                  ),
                  // Image.network(widget.carModel.imageUrl),
                  const SizedBox(height: 20),
                  Text(carModel!.model, style: txtTheme(context).titleLarge),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Rs. ",
                          style: txtTheme(
                            context,
                          ).bodyMedium!.copyWith(color: Colors.black54),
                        ),
                        TextSpan(
                          text: carModel!.pricePerDay.toString(),
                          style: txtTheme(context).titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        TextSpan(
                          text: " / day",
                          style: txtTheme(context).bodyMedium!.copyWith(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Date:*",
                              style: txtTheme(
                                context,
                              ).labelLarge!.copyWith(color: Colors.black),
                            ),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startDate = DateTime(
                                      picked.year,
                                      picked.month,
                                      picked.day,
                                    );
                                    totalDays =
                                        endDate.difference(startDate).inDays +
                                        1;
                                    totalPrice =
                                        totalDays * carModel!.pricePerDay;
                                  });
                                }
                              },
                              child: CustomTextFormField(
                                isEnabled: false,
                                controller: TextEditingController(
                                  text: DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(startDate),
                                ),

                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Date:*",
                              style: txtTheme(
                                context,
                              ).labelLarge!.copyWith(color: Colors.black),
                            ),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: startDate,
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() {
                                    endDate = DateTime(
                                      picked.year,
                                      picked.month,
                                      picked.day,
                                    );
                                    totalDays =
                                        (endDate.difference(startDate).inDays +
                                            1);
                                    print("totalDays: $totalDays");
                                    totalPrice =
                                        totalDays * carModel!.pricePerDay;
                                  });
                                }
                              },
                              child: CustomTextFormField(
                                isEnabled: false,
                                controller: TextEditingController(
                                  text: DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(endDate),
                                ),

                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Start Location:*",
                    style: txtTheme(
                      context,
                    ).labelLarge!.copyWith(color: Colors.black),
                  ),
                  CustomTextFormField(
                    controller: startLocationController,

                    isEnabled: false,
                    suffixIcon: const Icon(Icons.location_on),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Destination:*",
                    style: txtTheme(
                      context,
                    ).labelLarge!.copyWith(color: Colors.black),
                  ),

                  const SizedBox(height: 2),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search Location",
                          hintStyle: txtTheme(context).labelMedium,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      menuProps: const MenuProps(backgroundColor: Colors.white),
                    ),
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: colorScheme(context).outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: colorScheme(context).outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: colorScheme(context).outline,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 20.0),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Select City',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    filterFn:
                        (item, filter) =>
                            item.toLowerCase().contains(filter.toLowerCase()),
                    items:
                        (filter, loadProps) =>
                            citiesList
                                .where(
                                  (loc) => loc.toLowerCase().contains(
                                    filter.toLowerCase(),
                                  ),
                                )
                                .toList(),
                    itemAsString: (loc) => loc,
                    selectedItem: selectedCity,
                    onChanged: (val) {
                      setState(() {
                        selectedCity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (selectedCity != null) {
                final BookingModel bookingModel = BookingModel(
                  id: widget.bookingModel.id,
                  userId: widget.bookingModel.userId,
                  carId: widget.bookingModel.carId,
                  startDate: startDate,
                  endDate: endDate,
                  startLocation: startLocationController.text,
                  destination: selectedCity!,
                  totalPrice: totalPrice,
                  createdAt: widget.bookingModel.createdAt,
                  updatedAt: DateTime.now(),
                );

                final provider = Provider.of<BookingProvider>(
                  context,
                  listen: false,
                );
                provider.updateBooking(
                  booking: bookingModel,
                  onSuccess: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    final bottomNavProvider = Provider.of<BottomNavbarProvider>(
                      context,
                      listen: false,
                    );
                    bottomNavProvider.changeIndex(index: 1);
                  },
                );
              } else {}
            },
            child: Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Rs. ",
                        style: txtTheme(context).bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: totalPrice.toString(),
                        style: txtTheme(context).titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: " / $totalDays days",
                        style: txtTheme(context).bodyMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
