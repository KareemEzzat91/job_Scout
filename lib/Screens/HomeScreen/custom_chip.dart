// import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

class CustomChip extends StatefulWidget {
  const CustomChip({super.key});

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  int tag = 1;
  List<String> options =
  [
    "software","design","management","developer","security","senior"
  ];
  @override
  Widget build(BuildContext context) {
    return ChipsChoice.single(
      value: tag,
      onChanged: (val)=>setState(()=>tag=val),
      choiceItems: C2Choice.listFrom(
        source: options,
        value: (i,v)=>i,
        label: (i,v)=>v,
      ),
      choiceActiveStyle: const C2ChoiceStyle(color: Color(0xffffff0f)),
      choiceStyle: const C2ChoiceStyle(color: Color(0x0ffff4f5)),


    );
  }
}


