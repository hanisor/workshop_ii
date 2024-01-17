import 'package:flutter/material.dart';
import 'package:untitled2/services/databaseServices.dart';

class ReactivateScreen extends StatefulWidget {
  final String? currentUserId;

  const ReactivateScreen({required this.currentUserId});


  @override
  State<ReactivateScreen> createState() => _ReactivateScreenState();
}

class _ReactivateScreenState extends State<ReactivateScreen> {

  final reactivateEmailController = TextEditingController();
  final reactivatePasswordController = TextEditingController();
  final reactivateRePasswordController = TextEditingController();

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
          backgroundColor: (Colors.lightGreen[100])
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            Text(
              "Reactivate your account",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            Text(
              "Hello! Welcome Back!!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            Container(
              height: 200,
              width: 200,
              // Uploading the Image from Assets
              child:  Image.asset('assets/forgot password.png'),
            ),
            const SizedBox(height: 40),
            Text(
              "Please enter your details.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: reactivateEmailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Colors.deepOrangeAccent),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: reactivatePasswordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword1 = !_obscurePassword1;
                            });
                          },
                          icon: _obscurePassword1
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_outlined)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Colors.deepOrangeAccent),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: reactivateRePasswordController,
                    decoration: InputDecoration(
                      labelText: "Re-Enter Password",
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword2 = !_obscurePassword2;
                            });
                          },
                          icon: _obscurePassword2
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_outlined)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Colors.deepOrangeAccent),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(Colors.orange[900]),
                      ),
                      onPressed: () async {
                        print('Debug: Before calling reactivateAccount. ID: ${widget.currentUserId}');
                        DatabaseServices databaseServices = DatabaseServices();
                        await databaseServices.reactivateAccount(widget.currentUserId);
                        print('Debug: After calling reactivateAccount.');
                        // Show AlertDialog here
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Account Reactivated'),
                              content: const Text(
                                'Your account has been reactivated successfully.',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context); // Close the AlertDialog
                                    Navigator.pop(context); // Pop back to the previous screen
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },

                      child: Text("Reactivate"),
                    ),
                  ),

                ],
              ),

            ),

          ],
        ),

      ),


    );
  }
}
