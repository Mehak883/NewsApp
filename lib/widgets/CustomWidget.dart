import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class CustomElevatedButton extends StatefulWidget {
  final String message;
  final Future Function()? function;

  const CustomElevatedButton({
    required this.message,
    this.function,
  });

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });

        if (widget.function != null) {
          await widget.function!();
        }

        setState(() {
          loading = false;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 52, 81, 105)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(left: 150, right: 150, top: 12, bottom: 12),
        ),
        elevation: MaterialStateProperty.all(1),
      ),
      child: loading
          ? SpinKitWave(
              color: Colors.white,
              size: 25.0,
            )
          : FittedBox(
              child: Text(
                widget.message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
class CustomSnackBar {
  static void showSnackBar(
      BuildContext context, String label, Function() onPressed, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: label,
        onPressed: onPressed,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}