import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/mock/json_provider.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';

class GreetingConfigurationWidget extends StatefulWidget {
  final deviceSize;
  final User currentUser;
  const GreetingConfigurationWidget(this.deviceSize, this.currentUser);

  @override
  _GreetingConfigurationState createState() => _GreetingConfigurationState();
}

class _GreetingConfigurationState extends State<GreetingConfigurationWidget>
    with
        SingleTickerProviderStateMixin /*SingleTickerProviderStateMixin used for TabController vsync*/ {
  AdminCalls adminCalls = AdminCalls();

  late ConfigurartionSummary _greetingConfiguration =
      ConfigurartionSummary.init();

  late Bureaus _pickedBureau;
  late User _pickedUser;

  bool _showAbteilungList = false;
  bool _showNummerList = false;

  bool _isLoading = false;

  int currentTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    asyncLoadingData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> asyncLoadingData() async {
    setState(() {
      _isLoading = true;
    });
    /* _greetingConfiguration =
        await adminCalls.getGreetingConfiguration(widget.currentUser.token);*/
    _greetingConfiguration =
        await MyMockupDataProvider().getMockupData(context);
    _pickedBureau = _greetingConfiguration.bureaus![0];
    _pickedUser = _greetingConfiguration.users[0];
    setState(() {
      _isLoading = false;
    });
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
                    Center(child: Text("Placeholder1")),
                    Center(child: Text("Placeholder2")),
                    Center(child: Text("Placeholder3")),
                    //openingHours(widget.currentUser.token, "Kommune"),
                    //openingHours(widget.currentUser.token, "Abteilung"),
                    //openingHours(widget.currentUser.token, "Nummer"),
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
