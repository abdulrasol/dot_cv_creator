import 'package:dot_cv_creator/models/cv_modal.dart';
import 'package:dot_cv_creator/providers/statenotifier.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_flutter/icons_flutter.dart';

class PreivewWidget extends ConsumerWidget {
  const PreivewWidget({
    super.key,
    required this.textStyle,
    required this.textColor,
    required this.backgroundColor,
  });
  final TextStyle textStyle;
  final Color textColor;
  final Color backgroundColor;

  // A4 dimensions ratio (width:height = 1:1.4142)
  static const double a4Ratio = 1.4142;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cv = ref.watch(cvProvider);

    // تحديد النصوص حسب اتجاه اللغة
    final Map<String, String> labels = cv.cvLanguages == TextDirection.rtl
        ? {
            'contactDetails': 'معلومات التواصل',
            'skills': 'المهارات',
            'languages': 'اللغات',
            'hobbies': 'الهوايات',
            'socials': 'التواصل الاجتماعي',
            'profile': 'نبذة تعريفية',
            'education': 'التعليم',
            'experience': 'الخبرات',
            'certifications': 'الشهادات',
          }
        : {
            'contactDetails': 'Contact Details',
            'skills': 'Skills',
            'languages': 'Languages',
            'hobbies': 'Hobbies',
            'socials': 'Socials',
            'profile': 'Profile',
            'education': 'Education',
            'experience': 'Experience',
            'certifications': 'Certifications',
          };

    return Scaffold(
      body: Directionality(
        textDirection: cv.cvLanguages,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate dimensions while maintaining A4 ratio
            double pageWidth = constraints.maxWidth * 0.9;
            double pageHeight = pageWidth * a4Ratio;

            // If height exceeds screen height, recalculate based on height
            if (pageHeight > constraints.maxHeight * 0.9) {
              pageHeight = constraints.maxHeight * 0.9;
              pageWidth = pageHeight / a4Ratio;
            }

            // Calculate scale factor
            double scaleFactor = constraints.maxWidth / pageWidth;

            return Center(
              child: SingleChildScrollView(
                child: Transform.scale(
                  scale: 1.1,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      width: pageWidth,
                      height: pageHeight,
                      color: backgroundColor,
                      padding: EdgeInsets.all(pageWidth * 0.04),
                      child: Transform.scale(
                        scale: scaleFactor < 1 ? scaleFactor : 1,
                        child: _buildContent(cv, pageWidth, labels),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      CvModal cv, double pageWidth, Map<String, String> labels) {
    // Calculate responsive font sizes
    final double baseFontSize = pageWidth * 0.015;
    final TextStyle responsiveTextStyle = textStyle.copyWith(
      fontSize: baseFontSize,
      color: textColor,
    );

    final TextStyle headerStyle = responsiveTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: pageWidth * 0.03,
    );
    final TextStyle subtilteStyle = responsiveTextStyle.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: pageWidth * 0.02,
    );
    final TextStyle bodyStyle = responsiveTextStyle.copyWith(
      fontSize: baseFontSize,
      overflow: TextOverflow.fade,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(cv, headerStyle, bodyStyle, pageWidth, labels),
        SizedBox(height: pageWidth * 0.005),
        Divider(thickness: 1, color: textColor.withOpacity(0.3)),
        SizedBox(height: pageWidth * 0.01),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildSidebar(cv, headerStyle, subtilteStyle, bodyStyle,
                    pageWidth, labels),
              ),
              Expanded(
                flex: 3,
                child: _buildMainContent(
                    cv, headerStyle, bodyStyle, pageWidth, labels),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(CvModal cv, TextStyle headerStyle, TextStyle bodyStyle,
      double pageWidth, Map<String, String> labels) {
    return Row(
      children: [
        cv.profileImage != null
            ? CircleAvatar(
                radius: pageWidth * 0.08,
                backgroundImage: cv.profileImage != ''
                    ? NetworkImage(cv.profileImage!)
                    : const AssetImage('assets/images/avatar.png'),
              )
            : SizedBox(width: pageWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cv.name,
                  style: headerStyle.copyWith(fontSize: pageWidth * 0.05)),
              SizedBox(height: pageWidth * 0.001),
              Text(cv.jobTitle,
                  style: bodyStyle.copyWith(
                      fontSize: pageWidth * 0.03, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(
    CvModal cv,
    TextStyle headerStyle,
    TextStyle subtitleStyle,
    TextStyle bodyStyle,
    double pageWidth,
    Map<String, String> labels,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels['contactDetails']!, style: subtitleStyle),
        SizedBox(height: pageWidth * 0.001),
        _buildContactRow(FontAwesome.phone, cv.phone, bodyStyle, pageWidth),
        _buildContactRow(FontAwesome.at, cv.email, bodyStyle, pageWidth),
        _buildContactRow(
            FontAwesome.location_arrow, cv.address, bodyStyle, pageWidth),
        SizedBox(height: pageWidth * 0.01),
        // skills section
        cv.skills.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Text(labels['skills']!, style: subtitleStyle),
                  SizedBox(height: pageWidth * 0.001),
                  ...cv.skills.map(
                    (skill) => Padding(
                      padding: EdgeInsets.only(bottom: pageWidth * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              skill['skill'],
                              style: bodyStyle,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          RatingBar(
                            initialRating:
                                double.parse(skill['level'].toString()),
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: bodyStyle.fontSize!,
                            ignoreGestures: true,
                            ratingWidget: RatingWidget(
                              full:
                                  Icon(Icons.circle_rounded, color: textColor),
                              half:
                                  Icon(Icons.circle_outlined, color: textColor),
                              empty:
                                  Icon(Icons.circle_outlined, color: textColor),
                            ),
                            onRatingUpdate: (v) {},
                            // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        SizedBox(height: pageWidth * 0.01),
        cv.langauges.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Text('Langauges', style: subtitleStyle),
                  SizedBox(height: pageWidth * 0.001),
                  ...cv.langauges.map(
                    (lang) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lang['lang'],
                            style: bodyStyle.copyWith(
                              fontSize: bodyStyle.fontSize! * 1.2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        RatingBar(
                          initialRating: double.parse(lang['level'].toString()),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: bodyStyle.fontSize!,
                          ignoreGestures: true,
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.circle_rounded, color: textColor),
                            half: Icon(Icons.circle_outlined, color: textColor),
                            empty:
                                Icon(Icons.circle_outlined, color: textColor),
                          ),
                          onRatingUpdate: (v) {},
                          // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        cv.hobbies.isNotEmpty
            ? Column(
                children: [
                  SizedBox(height: pageWidth * 0.01),
                  Text(labels['hobbies']!, style: subtitleStyle),
                  ...cv.hobbies.map<Widget>(
                    (hobby) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.circle_rounded,
                            size: bodyStyle.fontSize!, color: textColor),
                        bodyStyle.fontSize!.horizontalSpace,
                        Text(
                          hobby,
                          style: bodyStyle.copyWith(
                            fontSize: bodyStyle.fontSize! * 1.2,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : const SizedBox(),
        SizedBox(height: pageWidth * 0.001),
        /*  ...cv.hobies.map(
          (hobby) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.circle_rounded,
                  size: bodyStyle.fontSize!, color: textColor),
              bodyStyle.fontSize!.horizontalSpace,
              Text(
                hobby,
                style: bodyStyle.copyWith(
                  fontSize: bodyStyle.fontSize! * 1.2,
                ),
              ),
            ],
          ),
        ),
        */
        SizedBox(height: pageWidth * 0.01),
        cv.socials.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Text(labels['socials']!, style: subtitleStyle),
                  SizedBox(height: pageWidth * 0.001),
                  ...cv.socials.map(
                    (social) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(social['platform'],
                            size: bodyStyle.fontSize!, color: textColor),
                        bodyStyle.fontSize!.horizontalSpace,
                        Text(
                          social['username'],
                          style: bodyStyle.copyWith(
                            fontSize: bodyStyle.fontSize! * 1.2,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
      ],
    );
  }

  Widget _buildContactRow(
      IconData icon, String detail, TextStyle style, double pageWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: pageWidth * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: style.fontSize,
            color: textColor,
          ),
          SizedBox(width: pageWidth * 0.01),
          Expanded(
            child: Text(
              detail,
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    CvModal cv,
    TextStyle headerStyle,
    TextStyle bodyStyle,
    double pageWidth,
    Map<String, String> labels,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pageWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cv.profile != ''
              ? _buildProfileSection(
                  cv, headerStyle, bodyStyle, pageWidth, labels)
              : 10.horizontalSpace,
          _buildDivider(pageWidth),
          _buildEducationSection(cv, headerStyle, bodyStyle, pageWidth, labels),
          _buildDivider(pageWidth),
          _buildExperienceSection(
              cv, headerStyle, bodyStyle, pageWidth, labels),
          _buildDivider(pageWidth),
          _buildCertificationSection(
              cv, headerStyle, bodyStyle, pageWidth, labels),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
    CvModal cv,
    TextStyle headerStyle,
    TextStyle bodyStyle,
    double pageWidth,
    Map<String, String> labels,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels['profile']!,
            style: headerStyle, textAlign: TextAlign.justify),
        SizedBox(height: pageWidth * 0.0001),
        Padding(
          padding: EdgeInsets.only(left: pageWidth * 0.01),
          child: Text(cv.profile, style: bodyStyle),
        ),
        SizedBox(height: pageWidth * 0.0001),
      ],
    );
  }

  Widget _buildEducationSection(
    CvModal cv,
    TextStyle headerStyle,
    TextStyle bodyStyle,
    double pageWidth,
    Map<String, String> labels,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels['education']!, style: headerStyle),
        SizedBox(height: pageWidth * 0.0001),
        ...cv.educations.map(
          (edu) => Padding(
            padding: EdgeInsets.only(
                bottom: pageWidth * 0.001, left: pageWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${edu['deg']} ${cv.cvLanguages == TextDirection.rtl ? 'في' : 'of'} ${edu['title']}',
                    style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: pageWidth * 0.001),
                Text(edu['uni']!, style: bodyStyle),
                Text(edu['date']!, style: bodyStyle),
              ],
            ),
          ),
        ),
        SizedBox(height: pageWidth * 0.0001),
      ],
    );
  }

  Widget _buildExperienceSection(
    CvModal cv,
    TextStyle headerStyle,
    TextStyle bodyStyle,
    double pageWidth,
    Map<String, String> labels,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels['experience']!, style: headerStyle),
        SizedBox(height: pageWidth * 0.0001),
        ...cv.experiences.map(
          (exp) => Padding(
            padding: EdgeInsets.only(
                bottom: pageWidth * 0.01, left: pageWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${exp['title']} at ${exp['at']}',
                    style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: pageWidth * 0.001),
                Text(exp['date']!, style: bodyStyle),
                Text(exp['text']!, style: bodyStyle),
              ],
            ),
          ),
        ),
        SizedBox(height: pageWidth * 0.0001),
      ],
    );
  }

  Widget _buildCertificationSection(
    CvModal cv,
    TextStyle headerStyle,
    TextStyle bodyStyle,
    double pageWidth,
    Map<String, String> labels,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels['certifications']!, style: headerStyle),
        SizedBox(height: pageWidth * 0.0001),
        ...cv.certifications.map(
          (cert) => Padding(
            padding: EdgeInsets.only(
                bottom: pageWidth * 0.01, left: pageWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cert['title'] ?? 'title',
                    style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: pageWidth * 0.001),
                Text(cert['from'] ?? 'from', style: bodyStyle),
                if (cert['date'] != null) Text(cert['date']!, style: bodyStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(double pageWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: pageWidth * 0.001,
        horizontal: pageWidth * 0.1,
      ),
      child: Divider(
        thickness: 1,
        color: textColor.withOpacity(0.3),
      ),
    );
  }
}
