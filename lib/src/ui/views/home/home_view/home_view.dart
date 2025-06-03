import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/home/home_view/home_projects_tasks_toggle.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (BuildContext context, HomeViewModel model, Widget? child) {
        return Scaffold(
            appBar: DefaultAppBar(title: 'Home', showBackButton: false),
            body: BackgroundContainer(
              background: 'background-2',
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 1)),
                          builder: (BuildContext context, snapshot) {
                          DateTime now = DateTime.now();
                          String dateStr =
                              DateFormat("EEEE, d'th' MMMM y").format(now);
                          String timeStr = DateFormat('HH:mm').format(now);
                          return Text(
                            '$dateStr | $timeStr',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          _buildMenuItem(
                              context,
                              model,
                              'Account',
                              IconsaxPlusLinear.profile_circle,
                              RoutePaths.account),
                          _buildMenuItem(context, model, 'Projects',
                              IconsaxPlusLinear.briefcase, RoutePaths.projects),
                          _buildMenuItem(context, model, 'Schedule',
                              IconsaxPlusLinear.calendar, RoutePaths.schedule),
                          _buildMenuItem(context, model, 'Network',
                              IconsaxPlusLinear.people, RoutePaths.network),
                          _buildMenuItem(
                              context,
                              model,
                              'EIA Basics',
                              IconsaxPlusLinear.attach_square,
                              RoutePaths.eiaBasics),
                          _buildMenuItem(context, model, "Check REG's",
                              IconsaxPlusLinear.book_1, RoutePaths.checkRegs),
                        ],
                      ),
                      SizedBox(height: 24),
                      HomeProjectsTasksToggle(),
                    ],
                  ),
                ),
              ),
            )));

      },
    );
  }

  Widget _buildMenuItem(BuildContext context, HomeViewModel model, String title,
      IconData icon, String routePath) {
    return GestureDetector(
      onTap: () {
        if (routePath == RoutePaths.projects ||
            routePath == RoutePaths.schedule ||
            routePath == RoutePaths.eiaBasics) {
          Navigator.pushNamed(context, routePath,
              arguments: {'fromHome': true});
        } else {
          switch (routePath) {
            case RoutePaths.network:
              model.navigateToNetwork();
              break;
            case RoutePaths.eiaBasics:
              model.navigateToEIABasics();
              break;
            case RoutePaths.checkRegs:
              model.navigateToCheckRegs();
              break;
            default:
              Navigator.of(context).pushNamed(routePath);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
