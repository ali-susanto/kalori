import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kalori/components/custom_button.dart';
import 'package:kalori/components/profile_scren_shimmer.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';

import '../enums.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<AuthService>(context, listen: false).autoLogin();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthService>(context, listen: false);
    Size size = MediaQuery.of(context).size;
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
      ),
      body: Consumer<AuthService>(
        builder: (context, state, child) {
          if (state.stateType == DataState.loading) {
            return const ProfileScreenShimmer();
          }
          if (state.stateType == DataState.error) {
            return const Center(
              child: Text('Gagal Mendapatkan Data'),
            );
          }
          return Column(
            children: [
              Column(
                children: [
                  AvatarGlow(
                    endRadius: 110,
                    glowColor: Colors.black,
                    duration: const Duration(seconds: 2),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      width: 175,
                      height: 175,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: viewModel.user.photoUrl == null
                            ? Image.asset(
                                "assets/logo/noimage.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                viewModel.user.photoUrl ?? '',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Text(
                    "${viewModel.user.fullName}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: ListTile(
                            title: const Text(
                              'Nama Depan',
                              style: TextStyle(fontSize: 12),
                            ),
                            horizontalTitleGap: 25,
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                viewModel.user.fullName!.split(' ').first,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: ListTile(
                            title: const Text(
                              'Nama Belakang',
                              style: TextStyle(fontSize: 12),
                            ),
                            horizontalTitleGap: 25,
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                viewModel.user.fullName!.split(' ').last,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: ListTile(
                            title: const Text(
                              'Email',
                              style: TextStyle(fontSize: 12),
                            ),
                            horizontalTitleGap: 25,
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                viewModel.user.email ?? 'Null',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          size: size,
                          color: Colors.red,
                          text: 'Sign Out',
                          onPressed: () async => await viewModel
                              .logOut()
                              .then((value) =>
                                  Fluttertoast.showToast(msg: 'User Log Out'))
                              .then((value) => Navigator.pushReplacementNamed(
                                  context, '/login')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Kaloriku App ",
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
          );
        },
      ),
    );
  }
}
