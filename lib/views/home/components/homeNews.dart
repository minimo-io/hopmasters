import 'package:Hops/components/app_title.dart';
import 'package:Hops/components/error.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/models/news.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeNews extends StatefulWidget {
  int count;
  HomeNews({this.count = 2, Key? key}) : super(key: key);

  @override
  State<HomeNews> createState() => _HomeNewsState();
}

class _HomeNewsState extends State<HomeNews> {
  late Future<List<News>> _news;

  @override
  void initState() {
    super.initState();
    _news = WordpressAPI.getNews(count: widget.count);
  }

  Widget _buildNewsCards(List<News> news, BuildContext context) {
    List<Widget> newsCards = [];
    for (int a = 0; a < news.length; a++) {
      // newsCards.add(Card(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       children: [
      //         NewsCard(news: news[a]),
      //         const SizedBox(
      //           height: 5.0,
      //         )
      //       ],
      //     ),
      //   ),
      // ));

      newsCards.add(NewsCard(news: news[a]));
      if (a != (news.length - 1)) {
        newsCards.add(const SizedBox(
          height: 2,
        ));
        newsCards.add(Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3),
          child: Divider(
            height: 10.0,
            color: Colors.grey.withOpacity(.5),
          ),
        ));
        newsCards.add(const SizedBox(
          height: 2,
        ));
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: newsCards,
      ),
    );
  }

  List<Widget> _buildShimmers(int count) {
    List<Widget> shimmers = [];
    for (int i = 0; i < count; i++) {
      shimmers.add(const SizedBox(height: 5.0));
      shimmers
          .add(const ContentPlaceholder(lineType: ContentLineType.twoLines));
      shimmers.add(const SizedBox(height: 5.0));
    }
    return shimmers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AppTitle(
            title: "Noticias",
            horizontalPadding: 25,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: InkWell(
                onTap: () => Helpers.launchURL("https://hops.uy/revista/"),
                child: Row(
                  children: const [
                    // Icon(
                    //   Icons.map,
                    //   color: Colors.black26,
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    Text(
                      "Ver más",
                      style: TextStyle(
                          color: BUTTONS_TEXT_DARK,
                          fontSize: titlesRightButtonsSize),
                    ),
                  ],
                ),
              )),
        ]),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: marginSide, vertical: 15),
          child: FutureBuilder(
              future: _news,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: _buildShimmers(widget.count)),
                        ));

                  default:
                    if (snapshot.hasError) {
                      if (DEBUG) print("News error.");
                      if (DEBUG) print(snapshot.error.toString());
                      return const ErrorMessage();
                    } else {
                      return _buildNewsCards(snapshot.data, context);
                    }
                }
              }),
        ),
      ],
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    Key? key,
    required this.lineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
          const SizedBox(height: 8.0),
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  final News news;
  static const double defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Helpers.launchURL("https://hops.uy/?p=" + news.id.toString()),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 45,
                width: 45,
                child: CircleAvatar(
                  radius: 1,
                  backgroundImage: NetworkImage(news.image),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Text(news.title,
                              style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black87,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500)),
                        ),
                        Row(
                          children: [
                            Text(
                              news.categoryName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: "Poppins",
                                fontSize: 11.0,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            Text(
                              news.publishDate,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11.0),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
