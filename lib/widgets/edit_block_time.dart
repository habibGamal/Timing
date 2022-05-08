import 'package:ecommerce/colors.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/time_pick.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBlockTime extends StatelessWidget {
  int _hours = 0;
  int _min = 45;
  EditBlockTime({
    Key? key,
  }) : super(key: key);
  void setHours(int hours) {
    _hours = hours;
  }

  void setMin(int min) {
    _min = min;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            width: MediaQuery.of(context).size.width * .9,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Edit the time block',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Consumer<Store>(builder: (context, store, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          TimePick(setHours, store.blockTimeHour, 12),
                          const Text('Hours'),
                        ],
                      ),
                      Column(
                        children: [
                          TimePick(setMin, store.blockTimeMin, 60),
                          const Text('Minutes'),
                        ],
                      ),
                    ],
                  );
                }),
                ElevatedButton(
                    onPressed: () {
                      Provider.of<Store>(context, listen: false)
                          .setBlockTimeHour(_hours);
                      Provider.of<Store>(context, listen: false)
                          .setBlockTimeMin(_min);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'))
              ],
            )),
      ),
    );
  }
}
