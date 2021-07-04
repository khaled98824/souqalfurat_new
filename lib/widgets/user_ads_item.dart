// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/screens/add_new_ad.dart';
import '../providers/ads_provider.dart';
//import 'package:real_shop/screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  static const routeName = '/user-product-item';
  final String id;
  final String name;
  final String imageUrl;

  const UserProductItem([this.id, this.name, this.imageUrl]);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return  ListTile(
      title: Text(name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print(' id user item $id');
               Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddNewAd(ctx , id)));
              }
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Delete faild',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
