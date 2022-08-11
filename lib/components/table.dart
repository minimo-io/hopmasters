import 'package:flutter/material.dart';

class HopsTable extends StatelessWidget {
  List<Map<String, dynamic>> rows;
  String? title;
  HopsTable({required this.rows, this.title, Key? key}) : super(key: key);

  List<Widget> _buildTable() {
    List<Widget> tableRows = [];
    if (title != null) {
      tableRows.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF565656))),
        ),
      );
    }
    rows.forEach((Map<String, dynamic> map) {
      tableRows.add(SizedBox(
        height: 30,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  if (map.containsKey("icon"))
                    Icon(
                      map["icon"],
                      size: 13,
                    ),
                  if (map.containsKey("icon"))
                    const SizedBox(
                      width: 5,
                    ),
                  Text(map["key"]!,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF444444))),
                ],
              ),
              Text(map["value"]!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF212121))),
            ],
          ),
        ),
      ));
      // tableRows.add(const Divider(
      //   color: Colors.black54,
      // ));
    });
    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildTable(),
    );
  }
}
