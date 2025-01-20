import 'package:dot_cv_creator/layouts/warper.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                          onPressed: () {}, child: const Text('About')),
                    )
                  ],
                ),
                50.verticalSpace,
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        textStyle: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.teal[200]),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 28)),
                    onPressed: () {
                      Flexify.go(
                        const Warper(),
                        animation: FlexifyRouteAnimations.fade,
                        animationDuration: const Duration(milliseconds: 500),
                      );
                    },
                    child: const Text('Create Your CV'),
                  ),
                ),
                50.verticalSpace,
                const Divider(),
                10.verticalSpace,
                const Text('Inspiration Gallery'),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: [
                    'assets/images/templates/1.png',
                    'assets/images/templates/2.png',
                    'assets/images/templates/3.png',
                  ].map((image) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.teal,
                      elevation: 8,
                      margin: const EdgeInsets.all(25),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        onPressed: () {},
                        onHover: (val) {},
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: LayoutBuilder(
                              builder: (context, boxConstraint) {
                                // mobile
                                return mediaQuery(
                                  boxConstraint,
                                  Image.asset(
                                    fit: BoxFit.contain,
                                    image,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                50.verticalSpace,
                /* Center(
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      'assets/images/templates/1.png',
                      'assets/images/templates/2.png',
                      'assets/images/templates/3.png',
                    ].map((image) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.teal,
                        elevation: 8,
                        margin: const EdgeInsets.all(25),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0)),
                          onPressed: () {},
                          onHover: (val) {},
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                fit: BoxFit.contain,
                                image,
                                width: MediaQuery.of(context).size.width / 6,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                 Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 2 / 4,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const GFImageOverlay(
                            height: 150,
                            width: 75,
                            boxFit: BoxFit.contain,
                            margin: EdgeInsets.all(8),
                            image: AssetImage('assets/images/templates/1.png'));
                      }),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mediaQuery(BoxConstraints boxConstraint, Widget widget) {
    if (boxConstraint.maxWidth < 480) {}
    // tablets
    if (boxConstraint.maxWidth < 768) {
      return SizedBox(width: boxConstraint.maxWidth * 0.7, child: widget);
    }
    // small laptops => 768px – 1024px
    if (boxConstraint.maxWidth < 1024) {
      return SizedBox(width: (boxConstraint.maxWidth / 2) * 0.9, child: widget);
    } else {
      return SizedBox(width: 230.rs, child: widget);
    }
  }

  Image mediaQuery2(BoxConstraints boxConstraint, String image) {
    if (boxConstraint.maxWidth < 480) {
      return Image.asset(
        fit: BoxFit.contain,
        image,
        width: boxConstraint.maxWidth * 0.9,
      );
    }
    // tablets
    if (boxConstraint.maxWidth < 768) {
      return Image.asset(
        fit: BoxFit.contain,
        image,
        width: boxConstraint.maxWidth * 0.7,
      );
    }
    // small laptops => 768px – 1024px
    if (boxConstraint.maxWidth < 1024) {
      return Image.asset(
        fit: BoxFit.contain,
        image,
        width: (boxConstraint.maxWidth / 2) * 0.9,
      );
    } else {
      return Image.asset(
          fit: BoxFit.contain,
          image,
          width: 230.rs // MediaQuery.of(context).size.width / 6,
          );
    }
  }
}
