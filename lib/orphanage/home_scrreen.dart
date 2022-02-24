// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_application_1/orphanage/homepage_widget.dart';
import 'package:flutter_application_1/orphanage/orphan_images.dart';
import 'package:flutter_application_1/orphanage/orphanage_about.dart';
import 'package:flutter_application_1/orphanage/orphanage_agelist.dart';
import 'package:flutter_application_1/orphanage/orphanage_certi.dart';
import 'package:flutter_application_1/orphanage/orphanage_needs.dart';
import 'package:flutter_application_1/user/login_screen.dart';

class OrphanageHome extends StatefulWidget {
  const OrphanageHome({Key? key}) : super(key: key);

  @override
  _OrphanageHomeState createState() => _OrphanageHomeState();
}

class _OrphanageHomeState extends State<OrphanageHome> {
  int activeIndex = 0;
  final screens = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          },
          child: const Icon(
            Icons.logout_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrphanageNeeds()));
                    },
                    child: Container(
                      child: const HomePageService(
                        color: Colors.white,
                        icons: 'assets/needs.png',
                        title: "Orphanage Needs",
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrphanageImages()));
                    },
                    child: Container(
                      child: const HomePageService(
                        color: Colors.white,
                        icons: 'assets/images.png',
                        title: "Add Images",
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrphanageAgelist()));
                    },
                    child: Container(
                      child: const HomePageService(
                        color: Colors.white,
                        icons: 'assets/details.png',
                        title: "Orphans List",
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrphanageCerti()));
                    },
                    child: Container(
                      child: const HomePageService(
                        color: Colors.white,
                        icons: 'assets/cert.png',
                        title: "Add Certificate",
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrphanageAbout()));
                    },
                    child: Container(
                      child: const HomePageService(
                        color: Colors.white,
                        icons: 'assets/details.png',
                        title: "Orphans List",
                      ),
                      alignment: Alignment.center,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
