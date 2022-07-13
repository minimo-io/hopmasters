import 'package:timeago/timeago.dart' as timeago;

class News {
  late String image, title, excerpt, categoryName, publishDate;
  late int id, categoryId;
  News(
      {required this.id,
      required this.title,
      required this.excerpt,
      required this.categoryName,
      required this.image,
      required this.categoryId,
      required this.publishDate});

  News.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"] ?? 0;
    title = (parsedJson["title"]["rendered"] ?? "");
    //description = (parsedJson["content"]["rendered"] ?? "");
    excerpt = parsedJson["excerpt"]["rendered"] ?? "";
    categoryName = "Experiencias";
    categoryId = parsedJson["categories"][0] ?? 0;
    image = parsedJson["jetpack_featured_media_url"] ?? "";

    String dateTimeAgo = "";
    if (parsedJson.containsKey("date_gmt")) {
      DateTime dateTImeAgoObject = DateTime.parse(parsedJson["date_gmt"]);
      dateTimeAgo = timeago.format(dateTImeAgoObject, locale: 'es').toString();
    }

    publishDate = dateTimeAgo;
  }

  static List<News> allFromResponse(List<dynamic> response) {
    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => News.fromJson(obj))
        .toList()
        .cast<News>();
  }
}
