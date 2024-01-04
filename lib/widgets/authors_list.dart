/// widgets/authors_list.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/author_model.dart';
import 'package:my_quotes_app_project/utils/fetch_authors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthorsList extends StatefulWidget {
  final Function(Author author) onAuthorTap;
  final String selectedAuthorId;

  const AuthorsList({
    Key? key,
    required this.onAuthorTap,
    this.selectedAuthorId = '',
  }) : super(key: key);

  @override
  State<AuthorsList> createState() => AuthorsListState();
}

class AuthorsListState extends State<AuthorsList> {
 String _searchKeywords = '';

 String generateAuthorsQuery() {
   if(_searchKeywords.isEmpty){
     return '/authors';
   }
   return '/search/authors?query=$_searchKeywords';
 }

 @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, /// DISABLE BACK BTN
        title: Container(
          margin: const EdgeInsets.only(top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: screenWidth - 112,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF4FF),
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
                      hintText: 'search author by name',
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
      ),
      body: FutureBuilder(
        future: fetchAuthors(generateAuthorsQuery()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return AuthorRow(
                    author: Author(
                    id: '1',
                    name: 'John Doe',
                    bio: 'A talented writer',
                    description: 'Author of many bestsellers',
                    link: 'https://www.johndoe.com',
                    quoteCount: 50,
                    slug: 'john-doe',
                    dateAdded: '2023-01-01',
                    dateModified: '2023-01-05',
                  ),
                    onAuthorTap: (author) => {
                      debugPrint('author tapped')
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
            List<Author> authors = snapshot.data as List<Author>;
            if(authors.isEmpty){
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
            return ListView.builder(
              itemCount: authors.length,
              itemBuilder: (context, index) {
                return AuthorRow(
                    author: authors[index],
                  onAuthorTap: widget.onAuthorTap,
                  selectedAuthorId: widget.selectedAuthorId,
                );
              },
            );
          }
        },
      ),
    );
  }

}

class AuthorRow extends StatelessWidget {
  final Author author;
  final Function(Author author) onAuthorTap;
  final String selectedAuthorId;

  const AuthorRow({
    Key? key,
    required this.author,
    required this.onAuthorTap,
    this.selectedAuthorId = '',
  }) : super(key:  key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4FF),
      ),
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          author.name,
          style: TextStyle(
          color: (author.id == selectedAuthorId)
              ? const Color(0xFFEB5A53) : Colors.black,
        ),
        ),
        subtitle: Text(
          author.description,
          style: TextStyle(
        color: (author.id == selectedAuthorId)
            ? const Color(0xFFEB5A53) : Colors.black,
        ),
        ),
        onTap: () {
          // Handle author row tap
          /// author object as argument for call back communication.
          onAuthorTap(author);
        },
      ),
    );
  }
}


















