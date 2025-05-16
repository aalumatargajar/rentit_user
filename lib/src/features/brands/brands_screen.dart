import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit_user/src/common/const/global_variable.dart';
import 'package:rentit_user/src/common/widgets/custom_back_button.dart';
import 'package:rentit_user/src/common/widgets/custom_search_bar.dart';
import 'package:rentit_user/src/features/brands/add_brand_screen.dart';
import 'package:rentit_user/src/features/brands/brands_provider.dart';
import 'package:rentit_user/src/features/brands/brands_widget.dart';
import 'package:rentit_user/src/features/brands/edit_brand_screen.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onTap: () => Navigator.of(context).pop()),
        title: Text("Brands"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintTxt: "Search Brand",
              onChanged: (value) {
                final brandsProvider = Provider.of<BrandsProvider>(
                  context,
                  listen: false,
                );
                brandsProvider.searchBrand(query: value);
              },
            ),
            SizedBox(height: 12),
            Consumer<BrandsProvider>(
              builder: (context, brandsProvider, child) {
                if (brandsProvider.brandsList.isEmpty) {
                  return Center(
                    child: Text(
                      "No Brands Found",
                      style: txtTheme(context).titleSmall,
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: brandsProvider.brandsList.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final brand = brandsProvider.brandsList[index];
                    return BrandsWidget.gridBrandsView(
                      context: context,
                      brand: brand,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
