
import 'package:find_my_car/screens/router_screen.dart';
import 'package:find_my_car/sheard/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late String initialRoute;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = onBoarding;
    } else {
      initialRoute = mapScreen;
    }
  });
  runApp(MyApp(appRouter: AppRouter(),));
}
class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme ,
      darkTheme: lightTheme ,
      themeMode: ThemeMode.light ,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }

}
