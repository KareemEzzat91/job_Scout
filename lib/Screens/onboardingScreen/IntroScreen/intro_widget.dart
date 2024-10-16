import 'package:flutter/material.dart';

import '../../Login&SignUp/LoginScreen.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
    required this.isout,
    required this.color,
    required this.title,
    required this.description,
    required this.skip,
    required this.image,
    required this.onTab,
    required this.index,});
  final isout  ;
  final String color;
  final String title;
  final String description;
  final bool skip;
  final String image;
  final VoidCallback onTab;
  final int index;


  @override
  Widget build(BuildContext context) {
    final height= MediaQuery.of(context).size.height;
    final width= MediaQuery.of(context).size.width;
    return ColoredBox(
      color: hexToColor(color),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.5,),
            child: SizedBox(
              width:  MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height / 1.86,
              child: AnimatedScale(scale: isout?0:1, duration:  const Duration(milliseconds:200),child: Image.asset(
                  image,
                fit: index==0 ? BoxFit.fitHeight:BoxFit.fill
            )
      ,),

            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.16,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? const Radius.circular(100) : const Radius.circular(0),
                    topRight: index == 2 ? const Radius.circular(100) : const Radius.circular(0),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Stack(
                  children: [
                    const SizedBox(height: 62,),
                    AnimatedPositioned(left: isout ?width+100:0,top: height *0.05, duration: Duration(milliseconds: 250),
                    child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 16,),
                    AnimatedPositioned(

                      duration: Duration(milliseconds: 250),
                      top: height *0.12,
                      right: isout ? width + 100 :-40,
                      child: Container(
                        width: width, // Adjust the width as needed
                        child: Text(
                          maxLines: 5,
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,

                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                                                  ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: skip
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );

                      },
                      child: const Text('Skip ', style: TextStyle(color: Colors.black),),
                    ),
                    GestureDetector(
                      onTap: onTab,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: hexToColor(color),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Icon(Icons.arrow_circle_right, color: Colors.white, size: 42),
                      ),
                    )
                  ],
                )
                    :  SizedBox(
                  height: 46,
                  child: MaterialButton(
                    color: hexToColor(color),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );

                    },
                    child: const Text('Get Started', style: TextStyle(color: Colors.white)),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));

  return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xFF000000 : 0x00000000));
}