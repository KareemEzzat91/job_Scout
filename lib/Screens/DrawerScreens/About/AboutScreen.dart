import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  Future<void> _launchUrl(String url) async {
    try {
      final Uri url0 = Uri.parse(url); // Convert the string URL to a Uri
      if (!await launchUrl(url0)) {
        throw Exception('Could not launch $url0');
      }
    }catch (e){
      throw Exception('Could not launch $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About JobScout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/photo_2024-09-16_15-28-23-removebg-preview.png"),
                  radius: 100,
                ),
              ),
              // App Description
              const SizedBox(height: 20),
              const Text(
                'About JobScout',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'JobScout is an advanced job search and application tracking app that helps you find your dream job and keep track of your applications. The app features job recommendations, detailed analytics, and a user-friendly interface to streamline your job hunting experience.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/New.jpg"),
                  radius: 100,
                ),
              ),

              // Team Section
              const SizedBox(height: 20),
              const Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We are a passionate team of developers who aim to build the best job search experience for users. Our team includes specialists in mobile app development, UI/UX design, and backend integration.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Team Members:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              BuildName("Kareem Ezzat Ibrahim (Team Leader),","https://www.linkedin.com/in/kareem-ezzat-21b99b220"),//https://www.linkedin.com/in/farah-gharieb-141628281
              BuildName("Farah Mohamed Gharieb,","https://www.linkedin.com/in/farah-gharieb-141628281"),//
              BuildName("Ahmed Abdelsalam Shehata,","https://www.linkedin.com/in/shehata%D9%80ahmed"),//https://www.linkedin.com/in/farah-gharieb-141628281
              BuildName("Ahmed Ashraf Salah,","https://www.linkedin.com/in/ahmed-ashraf-697577257"),//https://www.linkedin.com/in/farah-gharieb-141628281

              // Technologies Used
              const SizedBox(height: 30),
              const Text(
                'Technologies We Use',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'JobScout is built using Flutter, Firebase, and RESTful APIs to ensure seamless cross-platform performance, real-time notifications, and smooth integration with job data from various sources.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Tech Logos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Flutter.png', width: 80, height: 80),
                  const SizedBox(width: 20),
                   Image.asset('assets/images/Firebase.png', width: 80, height: 80),
                  const SizedBox(width: 20),
                   Image.asset('assets/images/ResApi.png', width: 80, height: 80),
                ],
              ),

              // Contact Information
              const SizedBox(height: 40),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'For inquiries or support, feel free to reach out to us at:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.blue),
                  const SizedBox(width: 10),
                  InkWell(child: const Text('kareemezzat1222@gmail.com'),onTap: (){
                    _launchUrl("mailto:kareemezzat1222@gmail.com");
                  },),
                ],
              ),              const SizedBox(height: 10),

               Row(
                children: [
                  const Icon(Icons.email, color: Colors.blue),
                  const SizedBox(width: 10),
                  InkWell(child: const Text('Farahm827@gmail.com'),onTap: (){
                    _launchUrl("mailto:Farahm827@gmail.com");

                  },),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 10),
                  InkWell(child: const Text('+20 112 590 8279'),onTap: (){
                    _launchUrl("https://wa.me/<+20 112 590 8279>?text=السلام عليكم");//https://wa.me/<+20 112 590 8279>?text=<message>
                  },),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 10),
                  InkWell(onTap: (){_launchUrl("https://wa.me/<+20 109 230 4229>?text=السلام عليكم");},child: const Text('+20 109 230 4229')),//https://wa.me/<+20 109 230 4229>?text=hello>"
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell BuildName(String name , String URL) {
    return InkWell(child:  Text('• ${name}',style: TextStyle(color: Colors.blue,fontSize: 20),),onTap: (){
              _launchUrl (URL);
            },);
  }
}
