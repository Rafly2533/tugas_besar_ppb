import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/home_ads_slider.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_product_grid.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header widget with logo and buttons
              HomeHeader(),
              
              // 2. Promotional slider with page dots
              HomeAdsSlider(),
              
              // 3. Category selector chips horizontal list
              HomeCategories(),
              
              // 4. Main Product Grid
              HomeProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
