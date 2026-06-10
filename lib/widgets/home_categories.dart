import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeCategories extends StatefulWidget {
  final Function(String)? onCategorySelected;
  const HomeCategories({Key? key, this.onCategorySelected}) : super(key: key);

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  int _selectedIndex = 0;

  final List<String> _categories = [
    'All',
    'Roses',
    'Lilies',
    'Sunflowers',
    'Tulips',
    'Orchids'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                if (widget.onCategorySelected != null) {
                  widget.onCategorySelected!(category);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  // Active category color matches the mint/greenish soft color in screenshots
                  color: isSelected 
                      ? const Color(0xFFD8ECDF) // Soft green/mint background
                      : AppTheme.border.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFC0E0CC) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected 
                          ? const Color(0xFF1E5631) // Deep green text for active
                          : AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
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
