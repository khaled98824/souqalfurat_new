// @dart=2.9
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
//import '../widgets/app_drawer.dart';
import '../widgets/user_ads_item.dart';
//import './edit_product.dart';

class UserAdsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<Void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your product'),
        actions: [
          IconButton(
            // onPressed: () =>
            //     Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      //drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, AsyncSnapshot snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(builder: (ctx, productsData, _) => Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, int index) => Column(
                  children: [
                    UserProductItem(
                        productsData.items[index].id,
                        productsData.items[index].name,
                        productsData.items[index].area),
                    Divider(),
                  ],
                )),
          ),
          ),
        ),
      ),
    );
  }
}
