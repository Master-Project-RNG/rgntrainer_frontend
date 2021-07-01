import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/widgets/greeting/greeting_tab_widget.dart';

class GreetingConfigurationWidget extends StatefulWidget {
  final Size deviceSize;
  //int = 1 ist Begrüssung konfigurieren, int = 2 ist Anrufbeantworter konfigurieren
  final int type;
  const GreetingConfigurationWidget(this.deviceSize, {required this.type});

  @override
  _GreetingConfigurationState createState() => _GreetingConfigurationState();
}

class _GreetingConfigurationState extends State<GreetingConfigurationWidget>
    with
        SingleTickerProviderStateMixin /*SingleTickerProviderStateMixin used for TabController vsync*/ {
  bool _showAbteilungList = false;
  bool _showNumberList = false;
  int currentTabIndex = 0;
  late TabController _tabController;

  void setShowAbteilung(bool a) {
    _showNumberList = a;
  }

  @override
  void initState() {
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
        height: 550,
        constraints: const BoxConstraints(minHeight: 520, minWidth: 500),
        width: 500,
        child: Card(
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: AppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  title: widget.type == 1
                      ? const Text("Begrüssung konfigurieren")
                      : const Text("Anrufbeantworter konfigurieren"),
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
                                if (_showNumberList == false) {
                                  _showNumberList = true;
                                } else {
                                  _showNumberList = false;
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
                    GreetingTabWidget("Kommune",
                        showAbteilungList: _showAbteilungList,
                        showNumberList: _showNumberList,
                        type: widget.type),
                    GreetingTabWidget("Abteilung",
                        showAbteilungList: _showAbteilungList,
                        showNumberList: _showNumberList,
                        type: widget.type),
                    GreetingTabWidget("Nummer",
                        showAbteilungList: _showAbteilungList,
                        showNumberList: _showNumberList,
                        type: widget.type),
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
