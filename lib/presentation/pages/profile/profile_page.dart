import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, });
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   height: 50,
            //   child: ListView(
            //     padding:
            //         const EdgeInsets.only(right: 5.0, left: 5.0, top: 8),
            //     scrollDirection: Axis.horizontal,
            //     children:
            //       controller.categories.keys
            //           .map(
            //             (category) => Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 3),
            //               child: FilterChip(
            //                 selected: controller.selectedCategories
            //                     .contains(category),
            //                 label: Text(
            //                   controller.getTranslatedCategory(category.tr()),
            //                   style: const TextStyle(
            //                     color: Colors.black87,
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //                 onSelected: (vaSelected) {
            //                   controller.toggleCategory(category);
            //                 },
            //               ),
            //             ),
            //           )
            //           .toList(),
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 * 1.4,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5, top: 10, left: 10, right: 10),
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
