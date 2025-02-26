import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar4(),
      body: Center(
          child: Container(
            color: Color(0xFFFCFCFC),
          )
      ),
    );
  }
}

AppBar _buildAppBar4() {
  return AppBar(
    backgroundColor: Color(0xFF262626),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    leading:  Padding(padding: const EdgeInsets.all(8.0),
      child: Image.asset('assets/amin_icon.png', fit: BoxFit.contain),),
    centerTitle: false,
    title: const Row(
      children: [
        Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xFFFCFCFC),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}