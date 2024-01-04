/// widgets/quote_carousel.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/quote_model.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:share_plus/share_plus.dart';

class QuoteCarousel extends StatefulWidget {
  final Future<List<Quote>> futureFetch;
  final String title;
  final Function(Quote quote) onQuoteTap;

  const QuoteCarousel({
    Key? key,
    required this.futureFetch,
    required this.title,
    required this.onQuoteTap,
  }) : super(key: key);

  @override
  State<QuoteCarousel> createState() => QuoteCarouselState();
}

class QuoteCarouselState extends State<QuoteCarousel> {
  final PageController  _quoteCardController = PageController(keepPage: true);

  // Key to uniquely identify the refresh widget
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // int _activeQuoteCard = 0;
  bool isMounted = false;

  @override
  void initState() {
    super.initState();
    isMounted = true;
    // initialization or setup code.
  }

  refreshQuotes(){
    _refreshIndicatorKey.currentState?.show();
    _quoteCardController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Archivo Black',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      onPressed: () => {
                        /// REFRESH QUOTES.
                        refreshQuotes()
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          SizedBox(
            height: 400, /// HEIGHT
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                // Trigger the refresh by calling setState
                setState(() {});

                // Simulate fetching data again
                await widget.futureFetch;
              },
              child: FutureBuilder(
                future: widget.futureFetch,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                      enabled: true,
                      child: PageView.builder(
                          controller: _quoteCardController,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index){
                            return QuoteCard(
                                quote: Quote(
                                  id: '1',
                                  content: 'Flutter is amazing!',
                                  author: 'John Doe',
                                  authorSlug: 'john-doe',
                                  length: 20,
                                  tags: ['flutter', 'programming', 'dart'],
                                ),
                              onQuoteTap: (quote) {
                                  debugPrint('quote tapped');
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
                    List<Quote> quotes = snapshot.data as List<Quote>;
                    if(quotes.isEmpty){
                      return const SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('No authors found'),
                            ),
                          ],
                        ),
                      );
                    }
                    return PageView.builder(
                        controller: _quoteCardController,
                        itemCount: quotes.length,
                        // onPageChanged: (int newQuoteCardIndex) {
                        //   setState(() {
                        //     _activeQuoteCard = newQuoteCardIndex;
                        //   });
                        // },
                        itemBuilder: (BuildContext context, int index){
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
                            onQuoteTap: widget.onQuoteTap,
                          );
                        },
                      onPageChanged: (index) {
                        /// Check if the last page is reached and trigger refresh
                        if (index == quotes.length - 1) {
                          refreshQuotes();
                        }
                      },
                    );
                  }
                },
              ),
            ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _quoteCardController.dispose();
    super.dispose();
    isMounted = false;
  }

}

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Function(Quote quote) onQuoteTap;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.onQuoteTap,
  });

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            ListTile(
              title: Container(
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ), /// for scrollable quote content (max height and single child scroll view used)
                child: SingleChildScrollView(
                  child: Text(
                    quote.content,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                  ],
                ),
              ),
            ),
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
                  ),
                ),
                IconButton(
                  onPressed: () => {
                    Share.share('${quote.content}\n- ${quote.author}')
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Color(0xFF265CDF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}












