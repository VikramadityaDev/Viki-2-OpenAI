import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/images.dart';
import '../../network/api_services.dart';
import 'full_screen.dart';

class DallePage extends StatefulWidget {
  const DallePage({
    super.key,
  });

  @override
  State<DallePage> createState() => _DallePageState();
}

class _DallePageState extends State<DallePage> {
  TextEditingController searchController = TextEditingController();
  bool imagesAvailable = false;
  bool searching = false;
  final double _value = 10;
  List<Images> imagesList = [];
  @override
  void initState() {
    super.initState();
    imagesAvailable = imagesList.isNotEmpty ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'DALL·E 2',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Column(
            children: [
              _formChat(),
              Expanded(
                child: imagesAvailable
                    ? MasonryGridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        itemCount: imagesList.length,
                        crossAxisSpacing: 10,
                        semanticChildCount: 6,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                CustomPageRoute(
                                  builder: (context) =>
                                      ImageView(imgPath: imagesList[index].url),
                                ),
                              );
                            },
                            child: Hero(
                              tag: imagesList[index].url,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6)),
                                height: index % 2 == 0 ? 180 : 250,
                                width: MediaQuery.of(context).size.width / 3,
                                child: ImageCard(
                                  imageData: imagesList[index].url,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: searchingWidget(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchingWidget() {
    if (searching) {
      return const CircularProgressIndicator(
        color: Color(0x88000000),
      );
    } else {
      return const Text(
        "Search for any image",
        style: TextStyle(color: Colors.white),
      );
    }
  }

  Widget _formChat() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: TextField(
        cursorColor: Colors.black87,
        controller: searchController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Type your message...',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: InkWell(
            onTap: () async {
              setState(() {
                searching = true;
              });
              imagesList = await submitGetImagesForm(
                context: context,
                prompt: searchController.text.toString(),
                n: _value.round(),
              );
              setState(() {
                imagesAvailable = imagesList.isNotEmpty ? true : false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          labelStyle: const TextStyle(fontSize: 12),
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade100,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade100,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.imageData});

  final String imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: CachedNetworkImage(
        imageUrl: imageData,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
            height: 150,
            width: 150,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.white,
              child: Container(
                height: 220,
                width: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            )),
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({builder}) : super(builder: builder);
}
