import 'package:ecommerce/colors.dart';
import 'package:ecommerce/models/mode.dart';
import 'package:ecommerce/pages/fullscreen_clock.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/clock.dart';
import 'package:ecommerce/widgets/modal_sheet_modes.dart';
import 'package:ecommerce/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block of time'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const ModalSheetModes();
                  });
            },
            icon: const FaIcon(FontAwesomeIcons.lightbulb),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Consumer<Store>(builder: (BuildContext context, store, child) {
            final Mode mode = store.currentMode;
            return GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const ModalSheetModes();
                  }),
              child: Container(
                alignment: Alignment.center,
                width: 80,
                decoration: BoxDecoration(
                    color: mode.color, borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        mode.icon,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        mode.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
          const Clock(),
        ],
      ),
      drawer: const Navbar(),
    );
  }
}
