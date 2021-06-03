import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/widgets/greeting/greeting_tab_widget.dart';

class GreetingConfigurationWidget extends StatefulWidget {
  final deviceSize;
  const GreetingConfigurationWidget(this.deviceSize);

  @override
  _GreetingConfigurationState createState() => _GreetingConfigurationState();
}

class _GreetingConfigurationState extends State<GreetingConfigurationWidget>
    with
        SingleTickerProviderStateMixin /*SingleTickerProviderStateMixin used for TabController vsync*/ {
  bool _showAbteilungList = false;
  bool _showNummerList = false;
  int currentTabIndex = 0;
  late TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      currentTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        height: 520,
        constraints: const BoxConstraints(minHeight: 520, minWidth: 500),
        width: widget.deviceSize.width * 0.3,
        child: Card(
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: AppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  title: const Text("Begrüssung konfigurieren"),
                  centerTitle: true,
                  elevation: 8.0,
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    (() {
                      if (currentTabIndex == 1) {
                        return InkWell(
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                if (_showAbteilungList == false) {
                                  _showAbteilungList = true;
                                } else {
                                  _showAbteilungList = false;
                                }
                              });
                            },
                          ),
                        );
                      } else if (currentTabIndex == 2) {
                        return InkWell(
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                if (_showNummerList == false) {
                                  _showNummerList = true;
                                } else {
                                  _showNummerList = false;
                                }
                              });
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }()),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        text: "Kommune",
                      ),
                      Tab(
                        text: "Abteilung",
                      ),
                      Tab(
                        text: "Nummer",
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GreetingTabWidget(
                        "Kommune", _showAbteilungList, _showNummerList),
                    GreetingTabWidget(
                        "Abteilung", _showAbteilungList, _showNummerList),
                    GreetingTabWidget(
                        "Nummer", _showAbteilungList, _showNummerList),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
