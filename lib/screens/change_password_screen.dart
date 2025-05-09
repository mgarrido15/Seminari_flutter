import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/users_provider.dart';
import '../services/UserService.dart';
import '../models/user.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final passwordController = TextEditingController();
  void changePassword(BuildContext context) async{
    final newPassword = passwordController.text;

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contrasenya no pot estar buida.')),
      );
      return;
    }
     final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No s\'ha trobat cap usuari.')),
      );
      return;
    }

    // Actualiza la contraseña del usuario
    final updatedUser = User(
      id: user.id,
      name: user.name,
      email: user.email,
      age: user.age,
      password: newPassword, 
    );

    try {
      final result = await UserService.updateUser(user.id!, updatedUser);
      userProvider.setUser(result);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrasenya actualitzada correctament.')),
      );
      }



    Navigator.of(context).pop();
  }
  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualitzar la contrasenya: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canviar Contrasenya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nova Contrasenya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Introdueix la nova contrasenya',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => changePassword(context),
              child: const Text('Actualitzar Contrasenya'),
            ),
          ],
        ),
      ),
    );
  }
}
 