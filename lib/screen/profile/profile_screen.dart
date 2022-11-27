import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async => await viewModel
                .logOut()
                .then((value) => Fluttertoast.showToast(msg: 'User Log Out'))
                .then((value) =>
                    Navigator.pushReplacementNamed(context, '/login')),
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              AvatarGlow(
                endRadius: 110,
                glowColor: Colors.black,
                duration: const Duration(seconds: 2),
                child: Container(
                  margin: EdgeInsets.all(15),
                  width: 175,
                  height: 175,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: viewModel.user.photoUrl! == "noimage"
                        ? Image.asset(
                            "assets/logo/noimage.png",
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            viewModel.user.photoUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Text(
                "${viewModel.user.name}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${viewModel.user.email}",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Update Status",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.person),
                    title: Text(
                      "Change Profile",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  // ListTile(
                  //   onTap: () => Get.changeTheme(Get.isDarkMode ? light : dark),
                  //   leading: Icon(Icons.color_lens),
                  //   title: Text(
                  //     "Change Theme",
                  //     style: TextStyle(
                  //       fontSize: 22,
                  //     ),
                  //   ),
                  //   trailing: Text(Get.isDarkMode ? "Dark" : "Light"),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kaloriku App",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "v.1.0",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
