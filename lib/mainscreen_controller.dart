import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/participant_model.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/account/Screen/account_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/screen/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'config/app_icons.dart';
import 'features/post/presentation/screen/add_post_screen.dart';

class MainScreenController extends GetxController {
  int currentIndex = 3;
  final search = TextEditingController();
  final UsersStateController stateController = Get.put(UsersStateController());
  // ignore: unused_field
  final ChatController _chatController = Get.put(ChatController());

  AppServices appServices = Get.find();
  var location = ''.obs;
  var jobTitle = ''.obs;

  void searchFilter() {
    debugPrint(
        'Performing search with location: ${location.value} and job title: ${jobTitle.value}');
    Get.back();
  }

  Widget myIcons(
      {String? svgAssetUrl, double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      svgAssetUrl!,
      // AppIcons.email,
      width: width ?? 30,
      height: height ?? 30,

      colorFilter:
          ColorFilter.mode(color ?? AppColors.iconColor, BlendMode.srcIn),
    );
  }

  List<BottomNavigationBarItem> getItems() {
    return [
      BottomNavigationBarItem(
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.home,
            color: AppColors.appColorPrimary,
          ),
          //  Icon(
          //   Iconsax.home_25,
          //   // Icons.home,
          // ),
          icon: myIcons(svgAssetUrl: AppIcons.homeBorder),
          // Icon(
          //   Iconsax.home_24,
          //   // Icons.home_filled
          // ),
          label: 'Home'),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.searchBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.search,
            color: AppColors.appColorPrimary,
          ),
          label: 'Search'
          // activeIcon: Icon(
          //   Iconsax.search_normal,
          //   // Icons.search
          // ),
          // icon: Icon(
          //   Iconsax.search_normal_1,
          //   // Icons.search,
          // ),
          ),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.plusBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.plus,
            color: AppColors.appColorPrimary,
          ),
          label: 'Add'
          // activeIcon: Icon(
          //     Icons.add_circle_outlined,
          //   ),
          //   icon: Icon(
          //     Icons.add_circle_outline_outlined,
          //   ),
          ),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.chatBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.chat,
            color: AppColors.appColorPrimary,
          ),
          label: 'Chat'
          // activeIcon: Icon(
          //     Iconsax.heart5,
          //     // Icons.heart_broken_outlined
          //   ),
          //   icon: Icon(
          //     Iconsax.heart,
          //     // Icons.heart_broken_rounded
          //   ),
          ),
      BottomNavigationBarItem(
          icon: myIcons(svgAssetUrl: AppIcons.userBorder),
          activeIcon: myIcons(
            svgAssetUrl: AppIcons.user,
            color: AppColors.appColorPrimary,
          ),
          label: 'Profile'
          // activeIcon: Icon(

          //     Iconsax.user,
          //     // Icons.person_2_outlined
          //   ),
          //   icon: Icon(
          //     Iconsax.user,
          //     // Icons.person_2,
          //   ),
          ),
    ];
  }

  //===========================================//

  List<Widget> listPage = [
    PostsScreen(),
    //  HomeScreen(),
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Center(child: Text("Home screen")),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.addPost(AddPostRequest(title: "title", content: "Upload more one multimedia", categoryId: 1)));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.updatePost(UpdatePostRequest(id: 8, allowComment: true, address: Address.updateRequest(city: 'taiz', street: "ss", lat: 10.2))));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.deletePost(90));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //     ElevatedButton(onPressed: () async{
    //       try{
    //       PostCommentRepository ds= PostCommentRepositoryImpl();
    //       (await ds.deleteSomePostMultimedia(DeleteSomePostMultimediaRequest(postId: 93, multimediaIds: [0])));
    //       } catch (e){
    //         print(">>>>>>>>>>>error<<<<<<<<<<<:$e");
    //       }
    //     }, child: const Text("Try", style: TextStyle(color: Colors.white))),
    //   ],
    // ),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("Search screen"))],
    ),
    AddPostScreen(),
    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Add Post"))],
    // ),
    // Padding(
    //   padding: const EdgeInsets.all(20),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       AppTextFormField(hintText: "User Id to start chatting with", obscureText: false, controller: userIdTextEdittingController,);
    //       ElevatedButton(
    //         onPressed: () {
    //           print(SharedPref.getUserToken());
    //           Get.to(() => ChatScreen());
    //         },
    //         child: Text("Open Chat"),
    //       )
    //     ],
    //   ),
    // ),
    TestChatScreen(),
    // TestAudio(),
    AccountScreen(),
    // const Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [Center(child: Text("Profile Screen"))],
    // ),
  ];

  List<IconData> bottomappbar = [
    Icons.home,
    Icons.notifications_active_outlined,
    Icons.person_pin_sharp,
    Icons.settings
  ];

  changePage(int index) {
    currentIndex = index;
    update();
  }
}

// ignore: must_be_immutable
class TestChatScreen extends StatelessWidget {
  ChatController chatController = Get.find();
  TestChatScreen({
    super.key,
  });

  final TextEditingController userIdTextEdittingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppTextFormField(
            hintText: "User Id to start chatting with",
            obscureText: false,
            controller: userIdTextEdittingController,
          ),
          Obx(() {
            if (chatController.getNewMessagesCount > 0) {
              return _buildWidgetWithCountAvatar(
                  _builElevatedButton(), chatController.getNewMessagesCount);
            }
            return _builElevatedButton();
          }),
        ],
      ),
    );
  }

  ElevatedButton _builElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        print(SharedPref.getUserToken());
        ParticipantModel? participant;
        if (userIdTextEdittingController.text.trim() != "") {
          try {
            participant = ParticipantModel(
              id: int.parse(userIdTextEdittingController.text.toString()),
              name: "Unknown",
            );
          } catch (e) {
            AppPrint.printError("Error in the inserted id: ${e.toString()}");
          }
        }
        Get.to(() => ChatScreen(user: participant));
      },
      child: const Text("Open Chat"),
    );
  }

  Stack _buildWidgetWithCountAvatar(Widget widget, int count) {
    return Stack(
      children: [
        widget,
        Positioned(
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: 1,
            child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                  color: Colors.red,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      count > 999 ? "999" : count.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    if (count > 999)
                      const Icon(
                        FontAwesomeIcons.plus,
                        size: 13,
                        color: Colors.white,
                      ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
