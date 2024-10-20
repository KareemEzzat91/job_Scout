import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../Helpers/customtextfiled/customtextfiled.dart';
import '../../Helpers/responsive/responsive.dart';
import 'LoginScreen.dart';
import 'cubit/sign_cubit.dart';

class Signupscreen extends StatelessWidget {
  late final String? Function(String?)? validator;
  final _nameController = TextEditingController();
  final _EmailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  Signupscreen({super.key});

  double TextSize(context,{required double isExtraSmallSize , required double isMobileSize,required double isMobileLarge,required double isIpadSize,required double isTabletSize,required double isLargeTabletSize,required double defaultSize} ){ return Responsive.isExtraSmall(context) ? isExtraSmallSize :
  Responsive.isMobile(context) ?isMobileSize:
  Responsive.isMobileLarge(context) ? isMobileLarge:
  Responsive.isIpad(context) ? isIpadSize:
  Responsive.isTablet(context) ? isTabletSize :
  Responsive.isLargeTablet(context) ? isLargeTabletSize : isLargeTabletSize;}

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
                ,   Row(
                  children: [
                    Text("Register Now! ",style :TextStyle(fontSize: TextSize(context,isExtraSmallSize:18,isMobileSize: 25,isMobileLarge:30,isIpadSize: 40,isTabletSize: 43,isLargeTabletSize: 50,defaultSize: 20  ),shadows: const [
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
                Text("Enter Your information Below ",style: TextStyle(color: Colors.grey.shade400,fontSize: TextSize(context,isExtraSmallSize:10,isMobileSize: 17,isMobileLarge:19,isIpadSize: 26,isTabletSize: 25,isLargeTabletSize: 40,defaultSize: 15  )),),
                Form(
                    key: _key,
                    child: Container(
                      child:Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: const Icon(Icons.person,color: Color(0xff0186c7)),
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
                              icon: const Icon(Icons.email_outlined,color:  Color(0xff0186c7)),
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
                              icon: const Icon(Icons.lock,color:  Color(0xff0186c7)),
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
                              icon: const Icon(Icons.mobile_friendly,color:  Color(0xff0186c7),),
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
                const SizedBox(height:40,),
                GestureDetector(
                  onTap: (){
                    bloc.SignUp(context,_key, _EmailController, _nameController, _passwordController, _mobileController);

                  },
                  child: Container (
                    height: 70,
                    decoration: BoxDecoration(
                        color:  const Color(0xff0186c7),
                        borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
                        boxShadow: const [BoxShadow(
                            color: Colors.grey,
                            offset:Offset(0.5, 0.5)
                        )]

                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<SignCubit,SignState>(
                         builder: (BuildContext context, SignState state) {
                           if (state is SignLoadingState){return const Center(child: CircularProgressIndicator() ,);}
                           return  const Text(
                             "Sign Up ",style: TextStyle(fontSize: 30,color: Colors.white),);
                         },

                        )],),
                  ),
                )
                ,const SizedBox(height:40,)

                , Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                     Text("Already a member  ? ",style: TextStyle(fontSize: TextSize(context,isExtraSmallSize:13,isMobileSize: 15,isMobileLarge:18,isIpadSize: 20,isTabletSize: 22,isLargeTabletSize: 30,defaultSize: 18  )),),
                    InkWell(onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );

                    }, child:  Text("Login",style: TextStyle(color: Color(0xff0186c7),fontSize: TextSize(context,isExtraSmallSize:13,isMobileSize: 15,isMobileLarge:18,isIpadSize: 20,isTabletSize: 22,isLargeTabletSize: 30,defaultSize: 18  ),fontWeight: FontWeight.bold),))
                  ],)


              ],
            ),
          ),
        ),
      ),
    );
  }
}
