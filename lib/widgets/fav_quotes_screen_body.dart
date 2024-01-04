/// widgets/fav_quotes_screen_body.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';
// import 'package:my_quotes_app_project/utils/fetch_quotes.dart';
// import 'package:my_quotes_app_project/widgets/quote_carousel.dart';
// import 'package:my_quotes_app_project/widgets/quote_of_the_day_display.dart';
import 'package:my_quotes_app_project/widgets/quotes_normal_builder.dart';

class FavQuotesScreenBody extends StatefulWidget {
  const FavQuotesScreenBody({super.key});

  @override
  State<FavQuotesScreenBody> createState() => FavQuotesScreenBodyState();
}

class FavQuotesScreenBodyState extends State<FavQuotesScreenBody> {

  @override
  Widget build(BuildContext context) {
    var quoteProvider = Provider.of<QuoteProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 20),
          margin: const EdgeInsets.only(bottom: 20),
          child: quoteProvider.isFavQuotesEmpty()
          ? Container(
            decoration: const BoxDecoration(
              // color: Colors.blue,
            ),
            height: screenHeight - 160,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('No Favourite quotes found')),
              ],
            ),
          )
          : QuotesNormalBuilder(
            quotes: quoteProvider.favQuotes,
            quotesContainerMaxHeight: screenHeight * 100,
            isScrollable: false,
            onQuoteTap: (quote) => {
              debugPrint(quote.content)
            },
          ),
      ),
    );
  }
}


















