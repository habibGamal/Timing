import 'package:ecommerce/colors.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/manage_tasks.dart';
import 'package:ecommerce/pages/session_logs.dart';
import 'package:ecommerce/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(ChangeNotifierProvider(
    create: (context) => Store(),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: MyColors.vilot),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.vilot),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.vilot, width: 3),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(MyColors.vilot),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(MyColors.vilot),
              side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: MyColors.vilot)),
            ),
          )),
      home: Home(),
      routes: {
        Routes.sessions: (context) => const SessionLogs(),
        Routes.manageTasks: (context) => const ManageTasks(),
      },
    );
  }
}
