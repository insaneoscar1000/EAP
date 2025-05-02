import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsView extends StatelessWidget {
  final Event event;

  const EventDetailsView({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventDetailsViewModel>.reactive(
      viewModelBuilder: () => EventDetailsViewModel(),
      onModelReady: (model) => model.initialize(event),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: model.event.name,
          showBackButton: true,
          actions: [
            if (model.canEdit)
              IconButton(
                icon: Icon(IconsaxPlusLinear.edit, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.editEvent,
                    arguments: model.event,
                  );
                },
              ),
          ],
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.event.flyerUrl.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(model.event.flyerUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection(
                            context,
                            'Organization',
                            model.event.organization,
                            IconsaxPlusLinear.building,
                          ),
                          _buildInfoSection(
                            context,
                            'Date',
                            DateFormat('HH:mm, dd MMMM yyyy')
                                .format(model.event.expiryDate.toDate()),
                            IconsaxPlusLinear.calendar,
                          ),
                          _buildInfoSection(
                            context,
                            'Contact Person',
                            model.event.contact.name,
                            IconsaxPlusLinear.profile_circle,
                          ),
                          _buildInfoSection(
                            context,
                            'Email',
                            model.event.contact.emailAddress,
                            IconsaxPlusLinear.message,
                            isEmail: true,
                          ),
                          SizedBox(height: 80), // Space for button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: model.event.linkUrl.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () async {
                          final url = Uri.parse(model.event.linkUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconsaxPlusLinear.global,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Visit Website',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isPhone = false,
    bool isEmail = false,
    bool isLink = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).secondaryHeaderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: isPhone || isEmail || isLink
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
