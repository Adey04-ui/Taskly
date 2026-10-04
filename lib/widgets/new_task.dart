import 'package:flutter/material.dart';

class NewTask extends StatelessWidget {
  const NewTask({super.key, this.isDark});
  final isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text('Task Title',
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                  Text('*')
                ],
              ),
            ],
          )
        ]
      ),
    );
  }
}