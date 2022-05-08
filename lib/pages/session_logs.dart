import 'package:ecommerce/colors.dart';
import 'package:ecommerce/store.dart';
import 'package:ecommerce/widgets/session_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionLogs extends StatelessWidget {
  const SessionLogs({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Logs'),
      ),
      body: Consumer<Store>(
        builder: (context, store, child) {
          return ListView(children: [
            child!,
            ...store.sessionsFrom
                .map((session) => SessionLog(
                      session,
                      key: Key(session.id.toString()),
                    ))
                .toList()
          ]);
        },
        child: const Switch(),
      ),
    );
  }
}

class Switch extends StatefulWidget {
  const Switch({Key? key}) : super(key: key);

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  int _value = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<Store>(context, listen: false)
          .setSessionsFrom(DateTime.now().subtract(Duration(days: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton<int>(
              dropdownColor: MyColors.white,
              value: _value,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  child: Text('Today'),
                  value: 1,
                  onTap: () {
                    setState(() {
                      _value = 1;
                    });
                    Provider.of<Store>(context, listen: false).setSessionsFrom(
                        DateTime.now().subtract(Duration(days: 1)));
                  },
                ),
                DropdownMenuItem(
                  child: Text('Last week'),
                  value: 7,
                  onTap: () {
                    setState(() {
                      _value = 7;
                    });
                    Provider.of<Store>(context, listen: false).setSessionsFrom(
                        DateTime.now().subtract(Duration(days: 7)));
                  },
                ),
                DropdownMenuItem(
                  child: Text('Last month'),
                  value: 30,
                  onTap: () {
                    setState(() {
                      _value = 30;
                    });
                    Provider.of<Store>(context, listen: false).setSessionsFrom(
                        DateTime.now().subtract(Duration(days: 30)));
                  },
                ),
                DropdownMenuItem(
                  child: Text('Last year'),
                  value: 360,
                  onTap: () {
                    setState(() {
                      _value = 360;
                    });
                    Provider.of<Store>(context, listen: false).setSessionsFrom(
                        DateTime.now().subtract(Duration(days: 360)));
                  },
                ),
              ],
              onChanged: (value) {}),
          IconButton(
            onPressed: () {
              Provider.of<Store>(context, listen: false).setSessionsFrom(
                  DateTime.now().subtract(Duration(days: _value)));
            },
            color: Colors.black54,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
