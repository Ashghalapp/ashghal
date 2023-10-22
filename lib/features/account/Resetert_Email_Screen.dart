import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widget/app_textformfield.dart';
import 'Screen/edit_profile_screen.dart';
import 'getx/Restart_Email_Controller.dart';
import 'widgets/header_widgets/header_account_widget.dart';

RestartEmailController restartpassword = Get.find();

class Restert_Email_Screen extends StatelessWidget {
  const Restert_Email_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "restart_Email",
          style: TextStyle(
            color: Colors.black,
            // color: Colors.grey[700],
            fontFamily: 'Nunito',
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            height: 100.0,
            decoration: const BoxDecoration(
              // color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 100.0,
              child: Image.asset(
                "assets/images/jobs.jpg",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: GetX(
                builder: (RestartEmailController controller) {
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !controller.Flage.value
                          ? Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: AppTextFormField(
                                    controller: controller.Email,
                                    hintText: '',
                                    lable: 'New Email',
                                    obscureText: true,
                                    textInputtype: TextInputType.phone,
                                    // onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    print(
                                        "${controller.Email.text}********************");
                                    controller
                                        .check_email(controller.Email.text);
                                  },
                                  child: const Text(
                                    "Check ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          // ? Row(
                          //     // crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Flexible(
                          //           flex: 2,
                          //           child: buildFieldWithLabel(
                          //               label: "New Password",
                          //               controller: Email)),
                          //       SizedBox(
                          //         width: 5,
                          //       ),
                          //       buildButtonWidget(
                          //           text: "Check",
                          //           onClick: () {
                          //             print(
                          //                 "${Email.text}********************");
                          //             controller.check_email(Email.text);
                          //           }),
                          //     ],
                          //   )
                          : controller.Flage.value
                              ? Column(
                                  children: [
                                    AppTextFormField(
                                      controller: restartpassword.Email,
                                      hintText: '',
                                      lable: 'Password',
                                      obscureText: true,
                                      textInputtype: TextInputType.phone,
                                      onSuffixIconPressed: () {
                                        //Get.to(() => EditAccountScreen());
                                      },
                                    ),
                                    // buildFieldWithLabel(
                                    //     label: "Password",
                                    //     isSecure: true,
                                    //     onClick: () =>
                                    //        ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildButtonWidget(
                                            text: "Next",
                                            onClick: () {
                                              // controller.Email.clear();
                                              controller.Flage.value = false;
                                              print(
                                                  "${controller.Flage.value}");
                                              Get.back();
                                            }),
                                        buildButtonWidget(
                                            text: "Cancel",
                                            onClick: () {
                                              // controller.Email.clear();
                                              controller.Flage.value = false;
                                              Get.back();
                                            }),
                                      ],
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: Text("Check Password"),
                                )
                    ],
                  );
                },
              ),
            ),
          ),
          // )
        ],
      ),
    );
  }
}

ElevatedButton buildButtonWidget(
    {required String text, required void Function() onClick}) {
  return ElevatedButton(
    onPressed: onClick,
    style: const ButtonStyle().copyWith(
      backgroundColor: const MaterialStatePropertyAll(Colors.indigo),
    ),
    child: Text(text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        )),
  );
}
