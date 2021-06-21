import 'package:flutter/material.dart';

class OptionsHome extends StatefulWidget {
  final Function call ;

  const OptionsHome( this.call);
  @override
  _OptionsHomeState createState() => _OptionsHomeState();
}

class _OptionsHomeState extends State<OptionsHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: MediaQuery.of(context).size.width -50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.grey[300]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (){
              //Navigator.push(context, BouncyPageRoute(widget: Exchange()));
            },
            child: Container(
              child: Row(
                children: [
                  Text('سعر الصرف',style: TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontWeight: FontWeight.w600
                  )
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.grey[400]),
            height: 30,
            width: 1,
          ),
          InkWell(
            onTap: (){

            },
            child: Container(
                child:Row(
                  children: [
                    Text('الإعلانات',style: TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontWeight: FontWeight.w600
                    )
                    )
                  ],
                ) ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.grey[400]),
            height: 30,
            width: 1,
          ),
          InkWell(
            onTap: (){

            },
            child: Container(
                child:Row(
                  children: [
                    Text('الأقسام',style: TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontWeight: FontWeight.w600
                    )
                    )
                  ],
                )),
          ),

        ],
      ),
    );
  }
}
