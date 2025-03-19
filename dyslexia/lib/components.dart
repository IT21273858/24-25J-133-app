import 'package:dyslexia/variables.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Reusable Text Input Field
class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: bodyStyle,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.white,
        hintText: hintText,
        hintStyle: bodyStyle.copyWith(color: Colors.grey),
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: appPrimaryColor)
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: appPrimaryColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 23.0,
        ),
      ),
    );
  }
}

// Reusable Button Component
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = appButtonColor,
    this.borderColor = appPrimaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shadowColor: appTextColor,
          foregroundColor: appPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  text,
                  style: bodyStyle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}

// Reusable Social Login Button Component
class SocialLoginButton extends StatelessWidget {
  final String imagePath;

  const SocialLoginButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Image.asset(imagePath, height: 40),
    );
  }
}

// Reusable Rounded Divider Component
class RoundedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: appPrimaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

// Slider of Card View Component
class SelectableCardSlider extends StatefulWidget {
  final List<Map<String, String>> cardData;
  final Function(String) onSelected;
  final String initialSelected;

  const SelectableCardSlider({
    super.key,
    required this.cardData,
    required this.onSelected,
    required this.initialSelected,
  });

  @override
  _SelectableCardSliderState createState() => _SelectableCardSliderState();
}

class _SelectableCardSliderState extends State<SelectableCardSlider> {
  String? selectedCard;

  @override
  void initState() {
    super.initState();
    selectedCard = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.cardData.length,
        itemBuilder: (context, index) {
          final card = widget.cardData[index];
          final isSelected = selectedCard == card['title'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCard = card['title'];
              });
              widget.onSelected(selectedCard!);
            },
            child: Container(
              width: 200,
              height: 68,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: isSelected ? cardBordercolor : cardBackgroundcolor,
                  width: 4,
                ),
                color: cardBackgroundcolor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(card['image']!, height: 80),
                  SizedBox(height: 10),
                  Text(
                    card['title']!,
                    style: cardheadingStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    card['description']!,
                    style: cardbodyStyle.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//GameScore Card
class GameScoreCardChild extends StatefulWidget {
  final List<Map<String, String>> cardData;
  final List<IconData> icons;

  const GameScoreCardChild({
    super.key,
    required this.cardData,
    required this.icons,
  });

  @override
  _GameScoreCard createState() => _GameScoreCard();
}

class _GameScoreCard extends State<GameScoreCardChild> {
  String? selectedCard;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.cardData.length,
        itemBuilder: (context, index) {
          final card = widget.cardData[index];
          final icon = widget.icons[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCard = card['title'];
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: cardBordercolor, width: 4),
                color: cardBackgroundcolor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  SizedBox(height: 10),
                  Text(
                    card['title']!,
                    style: cardheadingStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    card['description']!,
                    style: cardbodyStyle.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Child card
class ChildCardSlider extends StatelessWidget {
  final List<Map<String, String>> childData;

  const ChildCardSlider({super.key, required this.childData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175, // Ensures proper scrolling
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: childData.length,
        itemBuilder: (context, index) {
          final child = childData[index];

          return Container(
            width: 180,
            height: 175,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: cardBackgroundcolor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          // User Icon with Shadow
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child:
                                    child['image']!.startsWith('http')
                                        ? Image.network(
                                          child['image']!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              'assets/images/user.png',
                                            );
                                          },
                                        )
                                        : Image.asset(
                                          child['image']!,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              child['name']!,
                              style: cardheadingStyle,
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(height: 8),
                          Text(child['level']!, style: cardbodyStyle),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(child['lastLogged']!, style: childcardbodyStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Last logged on", style: childcardbodyStyle),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Child card slider for Dashboard
class ChildCardSliderDashboard extends StatelessWidget {
  final List<Map<String, String>> childData;

  const ChildCardSliderDashboard({super.key, required this.childData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175, // Ensures proper scrolling
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: childData.length,
        itemBuilder: (context, index) {
          final child = childData[index];

          return Container(
            width: 180,
            height: 175,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: childcardbodyColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(child['image']!),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              child['name']!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(height: 8),
                          Text(child['level']!, style: cardbodyStyle),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(child['lastLogged']!, style: childcardbodyStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Last logged on", style: childcardbodyStyle),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Graph Component
class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final String title;
  final String revenue;
  final String dropdownValue;
  final List<String> dropdownItems;
  final void Function(String?)? onDropdownChanged; // Fix type issue
  final Map<String, double> legendData;

  const BarChartWidget({
    super.key,
    required this.barGroups,
    required this.title,
    required this.revenue,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.onDropdownChanged,
    required this.legendData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(title, style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 5),
                      Text(
                        revenue,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButton<String>(
                          // dropdownColor: cardBackgroundcolor,
                          value: dropdownValue,
                          items:
                              dropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: onDropdownChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Dropdown
            ],
          ),

          SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 10);
                        String text = "";
                        switch (value.toInt()) {
                          case 0:
                            text = 'JAN';
                            break;
                          case 1:
                            text = 'FEB';
                            break;
                          case 2:
                            text = 'MAR';
                            break;
                          case 3:
                            text = 'APR';
                            break;
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(text, style: style),
                        );
                      },
                      reservedSize: 20,
                    ),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Legend
          Column(
            children:
                legendData.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  entry.value == 7
                                      ? Colors.purple
                                      : Colors.blue,
                            ),
                            SizedBox(width: 5),
                            Text(entry.key),
                          ],
                        ),
                        Text("${entry.value.toStringAsFixed(0)} %"),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

// Game card
class GameCardSlider extends StatelessWidget {
  final List<Map<String, String>> gameData;

  const GameCardSlider({super.key, required this.gameData});
  @override
  Widget build(BuildContext context) {
    print("^^^^^^^^^");
    print(gameData);
    return SizedBox(
      height: 172, // Adjusted height for better spacing
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gameData.length,
        itemBuilder: (context, index) {
          final game = gameData[index];

          return Container(
            width: 160,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: Image.asset(
                    game['image'].toString(),
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),

                // Points Display (Top-Right)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 14,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4),
                        Text(
                          game['score'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Game Name & Level (Bottom Section)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game['name'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Row(
                          spacing: 5,
                          children: [
                            Text(
                              'Level',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            Text(
                              game['level'] ?? "01",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> chartData; // Accept data from Dashboard

  const LineChartWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        duration: Duration(milliseconds: 5000),
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 20, showTitles: true),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text("10:00", style: TextStyle(fontSize: 10));
                    case 2:
                      return Text("12:00", style: TextStyle(fontSize: 10));
                    case 4:
                      return Text("14:00", style: TextStyle(fontSize: 10));
                    case 6:
                      return Text("16:00", style: TextStyle(fontSize: 10));
                    case 8:
                      return Text("18:00", style: TextStyle(fontSize: 10));
                    default:
                      return Text("", style: TextStyle(fontSize: 10));
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: chartData, // Dynamic data
              isCurved: true,
              color: linechartblueColor,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.purple.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Games score card
class GameScoreCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final int points;
  final double progress;

  const GameScoreCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.points,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 123,
              height: 123,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),

          // Game Info (Title & Description)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                // game name
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ).animate().flipH(duration: 500.ms),
                // Text(
                //   name,
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                // ),
                // description
                Text(
                  description,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ).animate().flip(delay: 600.ms),

                // Points & Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: pointsBackgroundColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Points : $points",
                        style: TextStyle(
                          color: pointsTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ).animate().flip(delay: 700.ms),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(fontSize: 14),
                    ).animate().flip(delay: 800.ms),
                  ],
                ),
                // Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.purple,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                ).animate().flip(delay: 900.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Button Component
class CustomSnakbar {
  static Future<void> showSnack(
    BuildContext context,
    String text, {
    Color bgcolor = wordhighlight,
    Color txtcolor = Colors.white,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: txtcolor)),
        backgroundColor: bgcolor,
      ),
    );
  }
}

class ReadingCards extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final int points;
  final double progress;

  const ReadingCards({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.points,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      height: progress,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: progress * 0.5,
              height: 123,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12),

          // Game Info (Title & Description)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                // game name
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Text(
                //   name,
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                // ),
                // description
                Text(
                  description,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ).animate().flip(delay: 600.ms),

                // Points & Progress Bar
              ],
            ),
          ),
        ],
      ),
    );
  }
}
