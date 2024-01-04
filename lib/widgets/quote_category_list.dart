/// widgets/quote_category_list.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/quote_category_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteCategoryList extends StatelessWidget {
  final Future<List<QuoteCategory>> fetchCategories;
  final Function(QuoteCategory quoteCategory) onQuoteCategoryTap;
  final String selectedCategoryId;

  const QuoteCategoryList({
    Key? key,
    required this.fetchCategories,
    required this.onQuoteCategoryTap,
    this.selectedCategoryId = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: fetchCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return CategoryRow(
                      category: QuoteCategory(
                        id: '1',
                        name: 'Inspiration',
                        slug: 'inspiration',
                        quoteCount: 100,
                        dateAdded: '2023-01-01',
                        dateModified: '2023-01-05',
                      ),
                    onQuoteCategoryTap: (quoteCategory) => {
                        debugPrint('quoteCategory tapped')
                    },
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<QuoteCategory> categories = snapshot.data as List<QuoteCategory>;

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                if(categories.isEmpty){
                  return const SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('No categories found'),
                        ),
                      ],
                    ),
                  );
                }
                return CategoryRow(
                    category: categories[index],
                  onQuoteCategoryTap: onQuoteCategoryTap,
                  selectedCategoryId: selectedCategoryId,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final QuoteCategory category;
  final Function(QuoteCategory quoteCategory) onQuoteCategoryTap;
  final String selectedCategoryId;

  const CategoryRow({
    Key? key,
    required this.category,
    required this.onQuoteCategoryTap,
    this.selectedCategoryId = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4FF),
      ),
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          category.name,
          style: TextStyle(
          color: (category.id == selectedCategoryId)
              ? const Color(0xFFEB5A53) : Colors.black,
        ),
        ),
        subtitle: Text(
            'tag: ${category.slug}',
          style: TextStyle(
            color: (category.id == selectedCategoryId)
                ? const Color(0xFFEB5A53) : Colors.black,
          ),
        ),
        onTap: () {
          // Handle category row tap
          onQuoteCategoryTap(category);
        },
      ),
    );
  }
}



















