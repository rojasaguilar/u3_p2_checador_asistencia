import 'package:flutter/material.dart';

class Gridhours extends StatefulWidget {
  final String? initHour;
  final Function(String) setHour;
  const Gridhours({this.initHour, required this.setHour, super.key});

  @override
  State<Gridhours> createState() => _GridhoursState();
}

class _GridhoursState extends State<Gridhours> {
  List<bool> isSelectedList = List.generate(18, (_) => false);
  int prev = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initHour != null && widget.initHour!.isNotEmpty) {
      prev = indexOfInitHour();
      isSelectedList[prev] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 6,
      children: List.generate(14, (index) {
        return InkWell(
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(4),
              constraints: BoxConstraints(
                minHeight: 0, // sin altura mínima
              ),
              child: Text(formatHour(index)),
              // padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelectedList[index]
                    ? Colors.blueAccent
                    : Colors.grey[300],
              ),
            ),
          ),

          onTap: () {
            setState(() {
              if (prev != -1) {
                isSelectedList[prev] = false;
              }
              isSelectedList[index] = !isSelectedList[index];
              prev = index;
              widget.setHour(formatHour(index));
            });
          },
        );
      }),
    );
  }

  String formatHour(int i) {
    if (i + 7 < 10) {
      return "0${i + 7}:00";
    }
    return "${i + 7}:00";
  }

  int indexOfInitHour() {
    if (widget.initHour!.length < 7) {
      return int.parse(widget.initHour![0]) - 7;
    }
    return int.parse(widget.initHour!.substring(0, 2)) - 7;
  }
}
