/// widgets/quotes_normal_builder.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/quote_model.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';
import 'package:share_plus/share_plus.dart';

class QuotesNormalBuilder extends StatelessWidget {
  final List<Quote> quotes;
  final double quotesContainerMaxHeight;
  final bool isScrollable;
  final Function(Quote quote) onQuoteTap;

  const QuotesNormalBuilder({
    Key? key,
    required this.quotes,
    required this.quotesContainerMaxHeight,
    required this.isScrollable,
    required this.onQuoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){

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
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          if(quotes.isEmpty){
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
          }
          return QuoteCard(
              quote: quotes[index],
              onQuoteTap: onQuoteTap,
          );
        },
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Function(Quote quote) onQuoteTap;

  const QuoteCard({
    Key? key,
    required this.quote,
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
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





























