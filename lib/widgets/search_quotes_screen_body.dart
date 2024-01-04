/// widgets/search_quotes_screen_body.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/utils/fetch_quotes.dart';
import 'package:my_quotes_app_project/widgets/quotes_future_builder.dart';
import 'package:my_quotes_app_project/widgets/filters.dart';

class SearchQuotesScreenBody extends StatefulWidget {
  const SearchQuotesScreenBody({super.key});

  @override
  State<SearchQuotesScreenBody> createState() => SearchQuotesScreenBodyState();
}

class SearchQuotesScreenBodyState extends State<SearchQuotesScreenBody> {
  String _searchKeywords = '';
  bool _isQuotesFiltered = false;

  String generateQuotesQuery() {
    if(_searchKeywords.isEmpty){
      setState(() {
        _isQuotesFiltered = false;
      });
      return '/quotes/random?limit=20';
    }
    setState(() {
      _isQuotesFiltered = true;
    });
    return '/search/quotes?query=$_searchKeywords';
  }

  String concatenateList(List<String> stringList) {
    String result = stringList.map((str) => str).join('|');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFEFF4FF),
            automaticallyImplyLeading: false,
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: screenWidth - 40,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        onChanged: (value) => {
                          setState((){
                            _searchKeywords = value;
                          })
                        },
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          icon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                            size: 25,
                          ),
                          hintText: 'search quotes by category',
                          hintStyle: TextStyle(
                            color: Color(0xFFB6BDD2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.filter_alt_sharp), text: 'Filters',),
                Tab(icon: Icon(Icons.check_box_outline_blank), text: 'Quotes',),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              const Filters(),
              QuotesFutureBuilder(
                fetchQuotes: fetchQuotes(generateQuotesQuery(), false, context, _isQuotesFiltered),
                quotesContainerMaxHeight: screenHeight,
                isScrollable: true,
                isSearchScreen: true,
                onQuoteTap: (quote) => {
                  debugPrint(quote.content)
                },
              ),
            ],
          )),
    );
  }
}



























