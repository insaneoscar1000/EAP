import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/network/find_team_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class FindTeamView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FindTeamViewModel>.reactive(
      viewModelBuilder: () => FindTeamViewModel(),
      builder: (BuildContext context, FindTeamViewModel model, Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'Find My Team',
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('Find Team View Coming Soon'),
          ),
        ),
      ),
    );
  }
}
