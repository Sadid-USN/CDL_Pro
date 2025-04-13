import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 * 1.4,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2.0,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return OverviewPage(
                        //         index: index,
                        //         book: filteredBooksList[index],
                        //         title: filteredBooksList[index].title,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      child: Row(
                        children: [
                          // Hero(
                          //   tag: filteredBooksList[index].image ?? noImage,
                          //   child: _BookImageCard(
                          //     id: filteredBooksList[index].id ?? "0.0",
                          //     image: filteredBooksList[index].image ?? noImage,
                          //   ),
                          // ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // _BuildRow(
                                //   label: LocaleKeys.libTitle.tr(),
                                //   data: book.title ?? "_",
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
