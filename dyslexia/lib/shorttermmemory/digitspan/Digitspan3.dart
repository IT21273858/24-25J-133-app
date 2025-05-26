import 'package:dyslexia/shorttermmemory/digitspan/Digitspan4.dart';
import 'package:dyslexia/services/digit_span_api_service.dart';
// ✅ Import API service
import 'package:flutter/material.dart';

class DigitSpan3TaskScreen extends StatefulWidget {
  final List<int> digitSequence;

  const DigitSpan3TaskScreen({super.key, required this.digitSequence});

  @override
  _DigitSpan3TaskScreenState createState() => _DigitSpan3TaskScreenState();
}

class _DigitSpan3TaskScreenState extends State<DigitSpan3TaskScreen> {
  List<int> _selectedNumbers = [];

  void _submit() async {
    var result = await DigitSpanApiService.validateSequence(
      _selectedNumbers,
      widget.digitSequence,
    );

    if (result != null &&
        result['status'] == true &&
        result['isCorrect'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DigitSpanTaskLevel4()),
      );
    } else {
      setState(() {
        _selectedNumbers.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Incorrect sequence! Try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            const Text(
              'Enter the sequence:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.15,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _selectedNumbers.isEmpty
                      ? "---"
                      : _selectedNumbers.join(", "),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_selectedNumbers.length <
                            widget.digitSequence.length) {
                          _selectedNumbers.add(index);
                        }
                      });
                    },
                    child: Text(
                      index.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _submit,
              child: const Text(
           