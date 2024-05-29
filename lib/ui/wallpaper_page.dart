import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_wallpaper/controller/wallpaper_controller.dart';
import 'package:flutter_wallpaper/ui/ringtone_page.dart';
import 'package:flutter_wallpaper/ui/video_wallpaper.dart';
import 'package:get/get.dart';

class WallpaperPage extends StatelessWidget {
  WallpaperPage({super.key});

  final WallpaperController wallpaperController =
      Get.put(WallpaperController());

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 30,
            blurStyle: BlurStyle.solid,
          ),
        ],
      ),
      controller: wallpaperController.advancedDrawerController,
      drawer: _buildDrawer(context),
      child: Scaffold(
        key: wallpaperController.scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: wallpaperController.handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: wallpaperController.advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    color: Colors.white,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
          title: const Text(
            'Wallpaper',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() => _buildMain(context)),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
        child: Column(
          children: [
            const Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ListTile(
            //   onTap: () {
            //     wallpaperController.advancedDrawerController.hideDrawer();
            //     Get.to(VideoWallpaper());
            //   },
            //   leading: Image.asset(
            //     "assets/icon/wallpaper_icon.png",
            //     color: Colors.white,
            //     height: 20,
            //     width: 20,
            //   ),
            //   title: const Text(
            //     "Video Wallpaper",
            //     style: TextStyle(color: Colors.white, fontSize: 18),
            //   ),
            // ),
            ListTile(
              onTap: () {
                    wallpaperController.advancedDrawerController.hideDrawer();
                    Get.to(RingTonePage());
              },
              leading: Image.asset(
                "assets/icon/ringtone_icon.png",
                color: Colors.white,
                height: 20,
                width: 20,
              ),
              title: const Text(
                "Ringtones",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset(
                "assets/icon/notification_icon.png",
                color: Colors.white,
                height: 20,
                width: 20,
              ),
              title: const Text(
                "Notification Sounds",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMain(BuildContext context) {
    return Stack(
      children: [
        _buildGridView(),
        _buildLoader(context),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: wallpaperController.dataList.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.black,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            wallpaperController.setHomeWallpaper(
                                index, context);
                            Navigator.pop(context);
                          },
                          leading: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 20,
                          ),
                          title: const Text(
                            "Set Wallpaper",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            wallpaperController.setLockWallpaper(
                                index, context);
                            Navigator.pop(context);
                          },
                          leading: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 20,
                          ),
                          title: const Text(
                            "Set Lock Screen",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            wallpaperController.setBothWallpaper(
                                index, context);
                            Navigator.pop(context);
                          },
                          leading: const Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          title: const Text(
                            "Set Both",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Image.network(
            wallpaperController.dataList[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildLoader(BuildContext context) {
    if (wallpaperController.isLoading.value == false) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Text("Please Wait",style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
}
