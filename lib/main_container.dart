import 'package:flutter/material.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() {
    return _MainContainerState();
  }
}

class _MainContainerState extends State<MainContainer> {
  TextEditingController input1Controller = TextEditingController();
  TextEditingController input2Controller = TextEditingController();
  TextEditingController input3Controller = TextEditingController();
  String resultText = "";

  bool isMeal = true;

  List<String> list_isMeal = [
    "Peso da crudo:",
    "Mangiare crudo:",
    "Peso da cotto",
    "Mangiare da cotto:"
  ];

  List<String> list_isNotMeal = [
    "Ingrediente Richiesto #1:",
    "Quantità in Casa #1:",
    "Ingrediente Richiesto #2:",
    "Utilizzare #2:"
  ];

  bool imagesPreloaded = false;

  final FocusNode input1FocusNode = FocusNode();
  final FocusNode input2FocusNode = FocusNode();
  final FocusNode input3FocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload images only once
    if (!imagesPreloaded) {
      precacheImage(AssetImage("assets/pasta.png"), context);
      precacheImage(AssetImage("assets/cake.png"), context);
      imagesPreloaded = true;
    }
  }

  void switchType() {
    setState(() {
      isMeal = !isMeal;
      // reset all text
      input1Controller.text = "";
      input2Controller.text = "";
      input3Controller.text = "";
      resultText = "";
    });
  }

  void computeResult() {
    double input1 = double.tryParse(input1Controller.text) ?? 0.0;
    double input2 = double.tryParse(input2Controller.text) ?? 0.0;
    double input3 = double.tryParse(input3Controller.text) ?? 0.0;

    if (input1 != 0) {
      double result = (input2 * input3) / input1;
      setState(() {
        resultText = result.round().toString();
      });
    } else {
      setState(() {
        resultText = "ERROR";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isMeal ? "assets/pasta.png" : "assets/cake.png",
                width: 150,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Pasticceria",
                    color: !isMeal ? Colors.black : Colors.grey,
                  ),
                  const SizedBox(width: 20),
                  Switch(
                    value: isMeal,
                    onChanged: (bool value) => switchType(),
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.blue,
                    inactiveTrackColor: Colors.blue[200],
                  ),
                  const SizedBox(width: 20),
                  CustomText(
                    "Ristorante",
                    color: isMeal ? Colors.black : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              buildInputField(isMeal ? list_isMeal[0] : list_isNotMeal[0],
                  input1Controller, input1FocusNode, input2FocusNode),
              const SizedBox(height: 20),
              buildInputField(isMeal ? list_isMeal[1] : list_isNotMeal[1],
                  input2Controller, input2FocusNode, input3FocusNode),
              const SizedBox(height: 20),
              buildInputField(isMeal ? list_isMeal[2] : list_isNotMeal[2],
                  input3Controller, input3FocusNode, null),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(isMeal ? list_isMeal[3] : list_isNotMeal[3]),
                  CustomText(resultText),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: computeResult,
                child: Text(
                  "Calcola",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isMeal ? Colors.green : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      FocusNode currentFocusNode, FocusNode? nextFocusNode) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(label),
            SizedBox(
              width: 100,
              child: TextField(
                controller: controller,
                focusNode: currentFocusNode,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isMeal ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  if (nextFocusNode != null) {
                    FocusScope.of(context).requestFocus(nextFocusNode);
                  } else {
                    computeResult();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget CustomText(String text, {Color color = Colors.black}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
