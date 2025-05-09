import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/users_provider.dart';
import '../services/UserService.dart';
import '../models/user.dart';

class EditarPerfilScreen extends StatelessWidget {
  EditarPerfilScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  void saveChanges(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No s\'ha trobat cap usuari.')),
      );
      return;
    }

    final updatedUser = User(
      id: user.id,
      name: nameController.text.isNotEmpty ? nameController.text : user.name,
      email: emailController.text.isNotEmpty ? emailController.text : user.email,
      age: int.tryParse(ageController.text) ?? user.age,
      password: user.password, 
    );

    try {
      final result = await UserService.updateUser(user.id!, updatedUser);
      userProvider.setUser(result);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualitzat correctament.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualitzar el perfil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    nameController.text = user.name;
    emailController.text = user.email;
    ageController.text = user.age.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nom',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Introdueix el teu nom',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Introdueix el teu email',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Edat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Introdueix la teva edat',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => saveChanges(context),
              child: const Text('Guardar Canvis'),
            ),
          ],
        ),
      ),
    );
  }
}