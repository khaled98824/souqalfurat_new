import 'package:flutter/material.dart';
import '../service/SerchData.dart';

class SearchAreaDesign extends StatefulWidget {
  @override
  _SearchAreaDesignState createState() => _SearchAreaDesignState();
}

class _SearchAreaDesignState extends State<SearchAreaDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: SerchData());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
        child: Container(
          height: 37,
          // width: 330,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.grey[400]),
          child: Stack(
            alignment: Alignment(0.3, 0),
            children: <Widget>[
              Text('!... إبحث في سوق الفرات',
                  style: Theme.of(context).textTheme.headline5),
              Align(
                  alignment: Alignment(0.9, 0),
                  child: Icon(
                    Icons.search,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}