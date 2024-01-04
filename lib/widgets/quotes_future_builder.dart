/// widget/quotes_future_builder.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/quote_model.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:share_plus/share_plus.dart';

class QuotesFutureBuilder extends StatelessWidget {
  final Future<List<Quote>> fetchQuotes;
  final double quotesContainerMaxHeight;
  final bool isScrollable;
  final bool isSearchScreen;
  final Function(Quote quote) onQuoteTap;

  const QuotesFutureBuilder({
    Key? key,
    required this.fetchQuotes,
    required this.quotesContainerMaxHeight,
    required this.isScrollable,
    required this.isSearchScreen,
    required this.onQuoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){

    return FutureBuilder<List<Quote>>(
      future: fetchQuotes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched, show a loading indicator
          return Skeletonizer(
              child: ListView.builder(
                shrinkWrap: true,
                physics: isScrollable
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  Quote quote = Quote(
                      id: '1',
                      content: 'Flutter is amazing!',
                      author: 'John Doe',
                      authorSlug: 'john-doe',
                      length: 20,
                      tags: ['flutter', 'programming', 'dart'],
                  );
                  return QuoteCard(
                      quote: quote,
                      isSearchScreen: isSearchScreen,
                      onQuoteTap: (quote) {
                        debugPrint('quote tapped');
                     },
                  );
                },
              ),
          );
        } else if (snapshot.hasError) {
          // If there's an error, display an error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If there's no data or the data is empty, display a message
          return const SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('No quotes found'),
                ),
              ],
            ),
          );
        } else {
          // If data is available, display the quotes.
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              // color: Color(0xFF265CDF),
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            constraints: BoxConstraints(
              maxHeight: quotesContainerMaxHeight,
            ),
            child: ListView.builder(
              /* shrinkWrap: true
                  => TO SET THE SIZE OF LIST VIEW builder SAME AS ITS CONTENT
                  => SO NO EXTRA SPACE ISSUE OCCURS
                  => BUT use max height (not height) in list view builder parent container.
                  */
              shrinkWrap: true,
              /* If physics:- never scrollable,
                  then SingleChildScrollView should wrap (be ancestor) of the list view builder */
              physics: isScrollable
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Quote quote = snapshot.data![index];
                return QuoteCard(
                    quote: quote,
                    isSearchScreen: isSearchScreen,
                     onQuoteTap: onQuoteTap,
                );
              },
            ),
          );
        }
      },
    );
  }
}

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final bool isSearchScreen;
  final Function(Quote quote) onQuoteTap;

  const QuoteCard({
    Key? key,
    required this.quote,
    required this.isSearchScreen,
    required this.onQuoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quoteProvider = Provider.of<QuoteProvider>(context, listen: true);

    return InkWell(
      onTap: () => {
        onQuoteTap(quote)
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSearchScreen
              ? const Color(0xFFEFF4FF)
              : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: ListTile(
          title: Text(
            quote.content,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  '- ${quote.author}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => {
                          quoteProvider.toggleAddRemoveAQuoteFromFavQuotes(quote)
                        },
                        icon: Icon(
                          quoteProvider.favQuotesHasThisQuote(quote.id)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: const Color(0xFFEB5A53),
                        )
                    ),
                    IconButton(
                        onPressed: () => {
                          Share.share('${quote.content}\n- ${quote.author}')
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Color(0xFF265CDF),
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




















