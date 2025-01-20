import 'package:dot_cv_creator/models/cv_modal.dart';
import 'package:dot_cv_creator/providers/statenotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_flutter/icons_flutter.dart';

class CvPreviewPage extends ConsumerWidget {
  const CvPreviewPage({
    super.key,
    required this.textStyle,
    required this.color,
    required this.backgroundColor,
  });

  final TextStyle textStyle;
  final Color color;
  final Color backgroundColor;

  // A4 dimensions ratio (width:height = 1:1.4142)
  static const double a4Ratio = 1.4142;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cv = ref.watch(cvProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(cv.name),
      ),
      body: LayoutBuilder(
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
                      child: _buildContent(cv, pageWidth),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(CvModal cv, double pageWidth) {
    // Calculate responsive font sizes
    final double baseFontSize = pageWidth * 0.025;
    final TextStyle responsiveTextStyle = textStyle.copyWith(
      fontSize: baseFontSize,
      color: color,
    );

    final TextStyle headerStyle = responsiveTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: baseFontSize * 1.2,
    );
    final TextStyle subtilteStyle = responsiveTextStyle.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: baseFontSize * 1.1,
    );
    final TextStyle bodyStyle = responsiveTextStyle.copyWith(
      fontSize: baseFontSize,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(cv, headerStyle, bodyStyle, pageWidth),
        SizedBox(height: pageWidth * 0.02),
        const Divider(thickness: 1),
        SizedBox(height: pageWidth * 0.02),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildSidebar(
                    cv, headerStyle, subtilteStyle, bodyStyle, pageWidth),
              ),
              Expanded(
                flex: 3,
                child: _buildMainContent(cv, headerStyle, bodyStyle, pageWidth),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(CvModal cv, TextStyle headerStyle, TextStyle bodyStyle,
      double pageWidth) {
    return Row(
      children: [
        CircleAvatar(
          radius: pageWidth * 0.08,
          backgroundImage: NetworkImage(
            cv.profileImage ?? 'https://placehold.co/600x400/png',
          ),
        ),
        SizedBox(width: pageWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cv.name, style: headerStyle),
              SizedBox(height: pageWidth * 0.01),
              Text(cv.jobTitle, style: bodyStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(CvModal cv, TextStyle headerStyle,
      TextStyle subtitleStyle, TextStyle bodyStyle, double pageWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Details', style: subtitleStyle),
        SizedBox(height: pageWidth * 0.02),
        _buildContactRow(FontAwesome.phone, cv.phone, bodyStyle, pageWidth),
        _buildContactRow(FontAwesome.at, cv.email, bodyStyle, pageWidth),
        _buildContactRow(
            FontAwesome.location_arrow, cv.address, bodyStyle, pageWidth),
        SizedBox(height: pageWidth * 0.03),
        Text('Skills', style: subtitleStyle),
        SizedBox(height: pageWidth * 0.02),
        ...cv.skills.map(
          (skill) => Padding(
            padding: EdgeInsets.only(bottom: pageWidth * 0.01),
            child: Text(
              skill['skill'],
              style: bodyStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(
      IconData icon, String detail, TextStyle style, double pageWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: pageWidth * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: style.fontSize,
            color: color,
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

  Widget _buildMainContent(CvModal cv, TextStyle headerStyle,
      TextStyle bodyStyle, double pageWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pageWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(cv, headerStyle, bodyStyle, pageWidth),
          _buildDivider(pageWidth),
          _buildEducationSection(cv, headerStyle, bodyStyle, pageWidth),
          _buildDivider(pageWidth),
          _buildExperienceSection(cv, headerStyle, bodyStyle, pageWidth),
          _buildDivider(pageWidth),
          _buildCertificationSection(cv, headerStyle, bodyStyle, pageWidth),
        ],
      ),
    );
  }

  Widget _buildProfileSection(CvModal cv, TextStyle headerStyle,
      TextStyle bodyStyle, double pageWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: headerStyle),
        SizedBox(height: pageWidth * 0.0001),
        Padding(
          padding: EdgeInsets.only(left: pageWidth * 0.01),
          child: Text(cv.profile, style: bodyStyle),
        ),
        SizedBox(height: pageWidth * 0.0001),
      ],
    );
  }

  Widget _buildEducationSection(CvModal cv, TextStyle headerStyle,
      TextStyle bodyStyle, double pageWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Education', style: headerStyle),
        SizedBox(height: pageWidth * 0.0001),
        ...cv.educations.map(
          (edu) => Padding(
            padding: EdgeInsets.only(
                bottom: pageWidth * 0.01, left: pageWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${edu['deg']} of ${edu['title']}',
                    style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: pageWidth * 0.01),
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

  Widget _buildExperienceSection(CvModal cv, TextStyle headerStyle,
      TextStyle bodyStyle, double pageWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Experience', style: headerStyle),
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
                SizedBox(height: pageWidth * 0.01),
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

  Widget _buildCertificationSection(CvModal cv, TextStyle headerStyle,
      TextStyle bodyStyle, double pageWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Certifications', style: headerStyle),
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
                SizedBox(height: pageWidth * 0.01),
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
      child: const Divider(thickness: 1),
    );
  }
}
