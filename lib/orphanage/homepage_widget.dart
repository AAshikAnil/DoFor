import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color.dart';

class HomePageService extends StatelessWidget {
  final color;
  final icons;
  final title;

  const HomePageService({Key? key, this.color, this.title, this.icons})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 30),
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            width: 160,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient: gradient1,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: Image.asset(
                    icons,
                    color: Colors.white,
                    height: 50,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
