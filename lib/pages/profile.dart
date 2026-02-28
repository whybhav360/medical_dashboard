import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Signin.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 45.0, right: 10),
          child: FloatingActionButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Signin()));
              },
              child: const Icon(Icons.logout)),
        ),
        appBar: AppBar(centerTitle: true, title: const Text('Profile')),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
              width: double.infinity,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Column(
                  children: [
                    Center(
                      child: Icon(
                        Icons.person,
                        size: 150,
                      ),
                    ),
                    Text(
                      "Vaibhav",
                      style: TextStyle(fontSize: 40),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
