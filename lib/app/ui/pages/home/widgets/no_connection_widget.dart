import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sem conexão com o servidor.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Clique na engrenagem para configurá-lo",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
