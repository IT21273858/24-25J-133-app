import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';

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
