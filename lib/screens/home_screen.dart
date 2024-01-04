/// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_quotes_app_project/widgets/quotes_screen_body.dart';
import 'package:my_quotes_app_project/widgets/search_quotes_screen_body.dart';
import 'package:my_quotes_app_project/widgets/fav_quotes_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/filter_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

  class HomeScreenState extends State<HomeScreen> {
   int selectedNavItemIndex = 0;

   Widget bodyBasedOnSelectedNavItemIndex() {
     if(selectedNavItemIndex == 0){
       return const QuotesScreenBody();
     } else if (selectedNavItemIndex == 1){
       /// wrapped by filter provider
       return ChangeNotifierProvider(
         create: (context) => FilterProvider(),
         child: const SearchQuotesScreenBody(),
       );
     }
     return const FavQuotesScreenBody();
   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FF),
      appBar: AppBar(
        automaticallyImplyLeading: false, // DISABLE BACK BTN.
        backgroundColor: const Color(0xFFEFF4FF),
        title: const Text(
            'My Quotes App',
          style: TextStyle(
            color: Color(0xFF265CDF),
          ),
        ),
      ),
      body:  WillPopScope(
          onWillPop: () async {
            bool shouldPop = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFFEFF4FF),
                  title: const Text('Confirmation'),
                  content: const Text('Do you want to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => {
                        /// EXIT APP.
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
            return shouldPop ?? false; // Default to false if there's an issue.
          },
        child: bodyBasedOnSelectedNavItemIndex(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 16,
        selectedFontSize: 16,
        unselectedItemColor: const Color(0xFFB9B9B9),
        selectedItemColor: const Color(0xFF265CDF),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outline_blank_rounded),
              label: 'Quotes'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Search'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites'
          )
        ],
        onTap: (index) {
          setState(() {
            // select the tapped nav item.
            selectedNavItemIndex = index;
          });
        },
        currentIndex: selectedNavItemIndex, // current index (current index item ll be selected)
      ),
    );
  }
}













