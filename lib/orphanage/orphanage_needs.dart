import 'package:flutter/material.dart';

class OrphanageNeeds extends StatefulWidget {
  const OrphanageNeeds({Key? key}) : super(key: key);

  @override
  _OrphanageNeedsState createState() => _OrphanageNeedsState();
}

class _OrphanageNeedsState extends State<OrphanageNeeds> {
  final List<String> needs = [
    'Dress'
        'PPE'
        'Food'
        'Library Books'
        'Stationary Items'
        'Light Bulbs'
        'Beds'
        'Blankets'
        'School Textbooks'
  ];
  final List<String> _selectedNeeds = [];
  List<String>? rolesvalues = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text('ADD Your Needs'),
        elevation: 0,
      ),
    );
  }
}
