import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobscout/Login&SignUp/cubit/sign_cubit.dart';
import '../customtextfiled/customtextfiled.dart';
import 'LoginScreen.dart';

class Signupscreen extends StatelessWidget {
  late final String? Function(String?)? validator;
  final _nameController = TextEditingController();
  final _EmailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignCubit>();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocListener <SignCubit,SignState>(

      listener: (BuildContext context, SignState state) {
        if (state is SignFaliureState) {
          Get.snackbar(
            "Error",
            state.error,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/photo_2024-09-16_15-28-23-removebg-preview.png",scale: 0.5,height:height/5,width: width/4, )
                ,  const Row(
                  children: [
                    Text("Register Now! ",style :TextStyle(fontSize: 25,shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black38,
                      ),
                    ],
                    ),),
                  ],
                ),
                const SizedBox(height: 8,),
                Text("Enter Your information Below ",style: TextStyle(color: Colors.grey.shade400),),
                Form(
                    key: _key,
                    child: Container(
                      child:Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: Icon(Icons.person),
                              controller: _nameController,
                              height: height,
                              text: "Name",
                              validator: (val) {
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .007,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: Icon(Icons.email_outlined),
                              controller: _EmailController,
                              height: height,
                              text: "Email",
                              validator: (val) {
                                if (!val!.isEmail) {
                                  return "this should be valid Email.";
                                } else if (val.length < 10) {
                                  return " email should be more than 10 letters";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .007,
                          ),
                          Padding(

                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: Icon(Icons.lock),
                              height: height,
                              controller: _passwordController,
                              text: "Password",
                              isPassword: true,
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password should be more than 7 letters";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .007,
                          ),
                          Padding(

                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: Icon(Icons.mobile_friendly),
                              height: height,
                              controller: _mobileController,
                              text: "Mobile",
                              isPassword: true,
                              validator: (val) {
                                if (val!.length != 11) {
                                  return "Phone should be 11 num";
                                }
                                return null;
                              },
                            ),
                          ),


                        ],
                      ) ,
                    )

                ),
                SizedBox(height:40,),
                GestureDetector(
                  onTap: (){
                    bloc.SignUp(context,_key, _EmailController, _nameController, _passwordController, _mobileController);

                  },
                  child: Container (
                    decoration: BoxDecoration(
                        color:  Colors.cyan,
                        borderRadius: BorderRadius.circular(20), // Optional: Rounded corners
                        boxShadow: const [BoxShadow(
                            color: Colors.grey,
                            offset:Offset(0.5, 0.5)
                        )]

                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<SignCubit,SignState>(
                         builder: (BuildContext context, SignState state) {
                           if (state is SignLoadingState){return Center(child: CircularProgressIndicator() ,);}
                           return  Text(
                             "Sign Up ",style: GoogleFonts.abyssinicaSil(fontSize: 40,color: Colors.white),);
                         },

                        )],),
                  ),
                )
                ,SizedBox(height:40,)

                , Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("Already a member  ? "),
                    InkWell(onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Loginscreen()),
                      );

                    }, child: Text("Login",style: GoogleFonts.agbalumo(color: Colors.cyan),))
                  ],)


              ],
            ),
          ),
        ),
      ),
    );
  }
}
