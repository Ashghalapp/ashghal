import 'package:ashghal_app_frontend/features/auth/data/repositories/user_provider_repository_impl.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';
import 'package:flutter/material.dart';

class Tester extends StatelessWidget {
  const Tester({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // try{
        UserProviderRepositoryImpl userProviderRepositoryImpl =
            UserProviderRepositoryImpl();
        RegisterProviderRequest request = RegisterProviderRequest.withEmail(
            name: "Hezbr", password: "123456", email: "bd2@gfgffgg.com", categoryId: 1, jobName: "hh");
        (await userProviderRepositoryImpl.registerUserWithEmail(request))
            .fold((l) => print("message: ${l.message}, errors: ${l.errors}"), (r) => print((r).name));
      }),
    );
  }
}
