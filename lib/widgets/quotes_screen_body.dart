/// widgets/quotes_screen_body.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/utils/fetch_quotes.dart';
import 'package:my_quotes_app_project/widgets/quote_carousel.dart';
import 'package:my_quotes_app_project/widgets/quote_of_the_day_display.dart';

class QuotesScreenBody extends StatefulWidget {
  const QuotesScreenBody({super.key});

  @override
  State<QuotesScreenBody> createState() => QuotesScreenBodyState();
}

class QuotesScreenBodyState extends State<QuotesScreenBody> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              QuoteOfTheDayDisplay(
                quotesContainerMaxHeight: screenHeight,
                isScrollable: false,
              ),
              const SizedBox(height: 10,),
              QuoteCarousel(
                futureFetch: fetchQuotes('/quotes/random?limit=10?maxLength=40', false, context, false),
                title: 'Other quotes',
                onQuoteTap: (quote) => {
                  debugPrint(quote.content)
                },
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ),
      );
  }
}













