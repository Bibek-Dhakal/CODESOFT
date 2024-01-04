/// widgets/quote_of_the_day_display.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/utils/fetch_quotes.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';
import 'package:my_quotes_app_project/widgets/quotes_future_builder.dart';
import 'package:my_quotes_app_project/widgets/quotes_normal_builder.dart';

class QuoteOfTheDayDisplay extends StatefulWidget {
  final double quotesContainerMaxHeight;
  final bool isScrollable;

  const QuoteOfTheDayDisplay({
    Key? key,
    required this.quotesContainerMaxHeight,
    required this.isScrollable,
  }) : super(key: key);

  @override
  State<QuoteOfTheDayDisplay> createState() => QuotesDisplayState();
}

class QuotesDisplayState extends State<QuoteOfTheDayDisplay> {

  @override
  Widget build(BuildContext context) {
    var quoteProvider = Provider.of<QuoteProvider>(context, listen: false);

    return SizedBox(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'Quote Of the day',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Archivo Black',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
          quoteProvider.isListWithQuoteOfTheDayEmpty()
          ? QuotesFutureBuilder(
                fetchQuotes: fetchQuotes('/quotes/random', true, context, false),
                quotesContainerMaxHeight: widget.quotesContainerMaxHeight,
                isScrollable: widget.isScrollable,
                isSearchScreen: false,
                onQuoteTap: (quote) => {
                 debugPrint(quote.content)
               },
              ) :
           QuotesNormalBuilder(
                quotes: quoteProvider.listWithQuoteOfTheDay,
                quotesContainerMaxHeight: widget.quotesContainerMaxHeight,
                isScrollable: widget.isScrollable,
                onQuoteTap: (quote) => {
                 debugPrint(quote.content)
                },
              ),
        ],
      ),
    );
  }
}


















