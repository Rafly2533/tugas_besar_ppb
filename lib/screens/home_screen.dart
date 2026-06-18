import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/home_header.dart';
import '../widgets/home_ads_slider.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_product_grid.dart';
import '../theme/app_theme.dart';
import '../providers/product_provider.dart';
import '../auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    final userData = authProvider.userData;
    if (userData != null) {
      final userId = userData['id'] is int 
          ? userData['id'] 
          : int.tryParse(userData['id'].toString()) ?? 0;
      if (userId > 0) {
        await productProvider.fetchProducts(userId);
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProducts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(),
                HomeAdsSlider(),
                HomeCategories(),
                HomeProductGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}