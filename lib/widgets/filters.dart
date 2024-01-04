import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/utils/fetch_quote_categories.dart';
import 'package:my_quotes_app_project/utils/fetch_quotes.dart';
import 'package:my_quotes_app_project/widgets/authors_list.dart';
import 'package:my_quotes_app_project/widgets/quote_category_list.dart';
import 'package:my_quotes_app_project/widgets/quotes_future_builder.dart';
import 'package:my_quotes_app_project/widgets/my_custom_vertical_tab_bar_view.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/filter_provider.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => FiltersState();
}

class FiltersState extends State<Filters> {
  bool isQuotesFiltered(String appliedAuthorSlug, String appliedTagSlug) {
    if (appliedAuthorSlug.isEmpty && appliedTagSlug.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var filterProvider = Provider.of<FilterProvider>(context, listen: true);
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight - 160,
      child: MyCustomVerticalTabBarView(
        initialIndex: 0,
        tabBarWidth: 80,
        tabBarHeight: 400,
        tabBarColor: const Color(0xFFEFF4FF),
        unselectedTabItemColor: const Color(0xFFB9B9B9),
        selectedTabItemColor: const Color(0xFF265CDF),
        tabBarItems: [
          TabBarItem(icon: Icons.person, text: 'Authors'),
          TabBarItem(icon: Icons.category, text: 'Categories'),
          TabBarItem(icon: Icons.done, text: 'Applied'),
          TabBarItem(icon: Icons.check_box_outline_blank, text: 'Filtered'),
        ],
        contentsArray: [
          AuthorsList(
            onAuthorTap: (author) => filterProvider.toggleAuthorSelection(author),
            selectedAuthorId: filterProvider.appliedAuthorId,
          ),
          QuoteCategoryList(
            fetchCategories: fetchQuoteCategories('/tags'),
            onQuoteCategoryTap: (quoteCategory) =>
                filterProvider.toggleCategorySelection(quoteCategory),
            selectedCategoryId: filterProvider.appliedTagId,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: (filterProvider.appliedAuthorSlug.isEmpty &&
                  filterProvider.appliedTagSlug.isEmpty)
                  ? const Text('No filters applied')
                  : Column(
                  children: [
                   filterProvider.appliedAuthorSlug.isEmpty
                      ? const SizedBox()
                      : Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                        color: Color(0xFFEFF4FF),
                       ),
                       child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                        Text(filterProvider.appliedAuthorSlug),
                        IconButton(
                          onPressed: () => filterProvider
                              .emptyAppliedAuthor(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  filterProvider.appliedTagSlug.isEmpty
                      ? const SizedBox()
                      : Container(
                       margin: const EdgeInsets.only(bottom: 10),
                       decoration: const BoxDecoration(
                       color: Color(0xFFEFF4FF),
                      ),
                       child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                        Text(filterProvider.appliedTagSlug),
                        IconButton(
                          onPressed: () =>
                              filterProvider.emptyAppliedTag(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          QuotesFutureBuilder(
            fetchQuotes: fetchQuotes(
              filterProvider.generateQuotesQuery(),
              false,
              context,
              isQuotesFiltered(
                filterProvider.appliedAuthorSlug,
                filterProvider.appliedTagSlug,
              ),
            ),
            quotesContainerMaxHeight: screenHeight,
            isScrollable: true,
            isSearchScreen: true,
            onQuoteTap: (quote) => debugPrint(quote.content),
          ),
        ],
      ),
    );
  }
}



























