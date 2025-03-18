import 'package:dyslexia/child/DashboardChild.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class LevelUnlocker extends StatefulWidget {
  @override
  _levelUnlocker createState() => _levelUnlocker();
}

class _levelUnlocker extends State<LevelUnlocker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            spacing: 50,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(FeatherIcons.xCircle, size: 24),
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardChild(),
                          ),
                        ),
                  ),
                ],
              ),
              Column(
                spacing: 24,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'New Level Unlocked',
                          style: registerNewLevelComp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/keybro.png',
                      height: 311,
                      width: 311,
                    ),
                  ),

                  SizedBox(
                    width: 230,
                    child: Text(
                      'Congratulation... You have unlocked your next level!',
                      style: unlockPagebodyStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
