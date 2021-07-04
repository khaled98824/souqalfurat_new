// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/screens/constants.dart';
import 'package:souqalfurat/screens/show_ad.dart';

class NewAdsItems extends StatefulWidget {
  @override
  _NewAdsItemsState createState() => _NewAdsItemsState();
}

class _NewAdsItemsState extends State<NewAdsItems> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Products>(context, listen: false).fetchNewAds();
  }

  @override
  Widget build(BuildContext context) {
    final getData = Provider.of<Products>(context, listen: false).fetchNewAds();
    final getAllData =
        Provider.of<Products>(context, listen: false).fetchAndSetProducts();

    return FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchNewAds(),
        builder: (ctx, snapshot) {
          final users = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return Consumer<Products>(
                  builder: (ctx, data, _) => GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    reverse: false,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 2,
                    addAutomaticKeepAlives: true,
                    addSemanticIndexes: true,
                    childAspectRatio: 0.7,
                    children: List.generate(
                        2,
                        (index) => NewAdsCard(
                              image: data.newItems[index].imagesUrl[0],
                              title: data.newItems[index].name,
                              country: data.newItems[index].area,
                              price: data.newItems[index].price.toInt(),
                              likes: data.newItems[index].likes,
                              views: data.newItems[index].views,
                              id: data.newItems[index].id,
                              date: data.newItems[index].time,
                              index: index,
                            )),
                  ),
                );
              }
          }
        });
  }
}

List likesList = [];

doLike(id, likes, index) {
  bool isLike;
}

bool like = false;

class NewAdsCard extends StatelessWidget {
  const NewAdsCard({
    Key key,
    this.date,
    this.index,
    this.id,
    this.likes,
    this.views,
    this.image,
    this.title,
    this.country,
    this.price,
    this.press,
  }) : super(key: key);

  final String image, title, country, id,date;
  final int price, likes, views, index;
  final Function press;

  @override
  Widget build(BuildContext context) {
    var ads = Provider.of<Products>(context);
    var getAll = Provider.of<Products>(context).fetchAndSetProducts();
    Size size = MediaQuery.of(context).size;
    bool isLike;

    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding / 4,
        top: kDefaultPadding / 2,
        right: kDefaultPadding / 4,
        //bottom: kDefaultPadding  ,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowAd(
                              adId: id,
                            )));
              },
              child: Image.network(image)),
          Container(
              height: 135,
              //width: 240,
              padding: EdgeInsets.all(kDefaultPadding / 3),
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      print('object');
                    },
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "$title\n".toUpperCase(),
                                      style:
                                          Theme.of(context).textTheme.headline5),
                                  TextSpan(
                                    text: "$country\n".toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Arabic Regular',
                                      color: kPrimaryColor.withOpacity(0.5),
                                      fontSize: 12
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$date\n".toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Arabic Regular',
                                      color: kPrimaryColor.withOpacity(0.5),
                                      fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: null,
                          child: Text(
                            '\$$price',
                            style: TextStyle(
                                fontFamily: 'Montserrat-Arabic Regular',
                                color: kPrimaryColor.withOpacity(0.9),
                                fontSize: 12
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (likesList.length > 0) {
                            for (int i = 0; i < likesList.length; i++) {
                              if (likesList[i] == id) {
                                isLike = true;
                                break;
                              } else {
                                isLike = false;
                              }
                            }
                            print(isLike);
                            if (isLike) {
                            } else {
                              Provider.of<Products>(context, listen: false)
                                  .updateLikes(id, likes, index);
                              likesList.add(id);
                            }
                          } else {
                            Provider.of<Products>(context, listen: false)
                                .updateLikes(id, likes, index);
                            likesList.add(id);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              like
                                  ? FontAwesomeIcons.heart
                                  : FontAwesomeIcons.heart,
                              size: 23,
                              color: Colors.orange,
                            ),
                            Consumer<Products>(
                              builder: (context, data, _) => Text(
                                'لايك : ${ads.newItems[index].likes}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    fontSize: 13,
                                    color: Colors.orange),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.eye,
                              size: 22,
                              color: Colors.orange,
                            ),
                            Text(
                              'مشاهدة : $views',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Arabic Regular',
                                  fontSize: 13,
                                  color: Colors.orange),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
