import 'package:dot_cv_creator/layouts/preivew_widget.dart';
import 'package:dot_cv_creator/models/cv_modal.dart';
import 'package:dot_cv_creator/providers/statenotifier.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:validatorless/validatorless.dart';

class FormPage extends ConsumerStatefulWidget {
  const FormPage({super.key});

  @override
  ConsumerState<FormPage> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  late TextEditingController nameController;
  late TextEditingController profileController;
  late TextEditingController jobTitleController;
  late TextEditingController profileImageController;
  late TextEditingController skillController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController depController;
  late TextEditingController uniController;
  late TextEditingController langController;
  late TextEditingController expAtController;
  late TextEditingController expTextController;
  late TextEditingController expTitleController;
  late TextEditingController cerTitleController;
  late TextEditingController cerFromController;
  late TextEditingController hobiesFromController;
  late TextEditingController socialFromController;
  // final cv = ref.watch(userProvider);
  //final user = ref.watch(userProvider);
  //final ProviderListenable<c.CvModal> cv;

  String? selectedValueEdu;
  int? selectedValuelang;
  double selectedValueSkill = 1;
  IconData? selectedValueContact;
  IconData? selectedValueSocial;
  String? startDateEdu;
  String? startDateExp;
  String? endDateEdu;
  String? endDateExp;
  List<bool> isOpenListIndex = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final List<String> range = [
    'Beginner',
    'Moderate',
    'Good',
    'Very good',
    'Fluent',
  ];

  @override
  void initState() {
    super.initState();
    final cv = ref.read(cvProvider);
    nameController = TextEditingController(text: cv.name);
    profileController = TextEditingController(text: cv.profile);
    jobTitleController = TextEditingController(text: cv.jobTitle);
    profileImageController = TextEditingController(text: cv.profileImage);
    phoneController = TextEditingController(text: cv.phone);
    emailController = TextEditingController(text: cv.email);
    addressController = TextEditingController(text: cv.address);
    skillController = TextEditingController();
    depController = TextEditingController();
    uniController = TextEditingController();
    langController = TextEditingController();
    expAtController = TextEditingController();
    expTitleController = TextEditingController();
    expTextController = TextEditingController();
    cerTitleController = TextEditingController();
    cerFromController = TextEditingController();
    hobiesFromController = TextEditingController();
    socialFromController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    profileController.dispose();
    profileImageController.dispose();
    jobTitleController.dispose();
    skillController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    depController.dispose();
    uniController.dispose();
    langController.dispose();
    expAtController.dispose();
    expTextController.dispose();
    expTitleController.dispose();
    cerFromController.dispose();
    cerTitleController.dispose();
    hobiesFromController.dispose();
    socialFromController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cv = ref.watch(cvProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Builder'),
        actions: [
          TextButton(
              onPressed: () {
                Flexify.go(
                  PreivewWidget(
                      textStyle: GoogleFonts.tajawal(),
                      textColor: Colors.black87,
                      backgroundColor: Colors.white70),
                );
              },
              child: const Text('preview'))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth < 768) {
            return fromSection(cv);
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: fromSection(cv),
                ),
                Expanded(
                  flex: 3,
                  child: fromSection(cv),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget fromSection(CvModal cv) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // name
          ExpansionPanelList(
            children: [
              accordingItem('Personal Details', 0,
                  identifySection(context, cv, cv.profileImage)),
              accordingItem(
                  'Education', 1, educationSection(context, cv.educations)),
              accordingItem('Skills', 2, skillsSection(context, cv.skills)),
              accordingItem('Experiences', 3,
                  experiencesSection(context, cv.experiences)),
              accordingItem(
                  'Languages', 4, languagesSection(context, cv.langauges)),
              accordingItem('Certifications', 5,
                  certificationSection(context, cv.certifications)),
              accordingItem('Hobbies', 6, hobbiesSection(context, cv.hobies)),
              accordingItem(
                  'Social links', 7, socialSection(context, cv.socials)),
            ],
            expansionCallback: (index, isOpen) {
              setState(() {
                isOpenListIndex[index] = isOpen;
              });
            },
            animationDuration: const Duration(seconds: 1),
            expandedHeaderPadding: const EdgeInsets.all(8),
            dividerColor: Colors.purple,
            elevation: 2,
            expandIconColor: Colors.purpleAccent,
            materialGapSize: 16.0,
          ),
        ],
      ),
    );
  }

  ExpansionPanel accordingItem(String title, int index, Widget child) =>
      ExpansionPanel(
        headerBuilder: (context, isOpen) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: GoogleFonts.tajawal(fontSize: 18.rs),
            ),
          );
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
        isExpanded: isOpenListIndex[index],
        canTapOnHeader: true,
        splashColor: Colors.amber,
      );

  Column identifySection(context, cv, image) {
    return Column(
      children: [
        Row(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final ImagePickerPlugin picker = ImagePickerPlugin();
                  final image = await picker.getImageFromSource(
                      source: ImageSource.camera);
                  if (image?.path != null) {
                    ref
                        .read(cvProvider.notifier)
                        .updateProfileImage(image!.path);
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(const CircleBorder()),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
                  backgroundColor:
                      WidgetStateProperty.all(Colors.blue), // <-- Button color
                  overlayColor:
                      WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.red; // <-- Splash color
                    }
                    return null;
                  }),
                ),
                child: CircleAvatar(
                  radius: 50.rs,
                  backgroundImage: NetworkImage(
                    image ?? 'https://placehold.co/600x400/png',
                  ),
                ),
              ),
            ),

            //18.horizontalSpace,
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      ref.read(cvProvider.notifier).updateName(value);
                    },
                  ),
                  16.verticalSpace,
                  // job title
                  TextField(
                    controller: jobTitleController,
                    decoration: const InputDecoration(labelText: 'Job Title'),
                    onChanged: (value) {
                      ref.read(cvProvider.notifier).updateJobTitle(value);
                    },
                  ),
                  16.verticalSpace,
                ],
              ),
            )
          ],
        ),
        4.verticalSpace,
        Row(
          children: [
            Text(
              'Contacts Details',
              style: GoogleFonts.tajawal(fontSize: 14.rs),
            ),
            const Expanded(
                child: Divider(
              indent: 10,
            )),
          ],
        ),
        4.verticalSpace,
        TextField(
          controller: phoneController,
          keyboardType: const TextInputType.numberWithOptions(),
          decoration: const InputDecoration(
            labelText: 'Phone',
            icon: Icon(FontAwesome.phone),
          ),
          onChanged: (value) {
            ref.read(cvProvider.notifier).updatePhone(value);
          },
        ),
        16.verticalSpace,
        // job title
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesome.at),
          ),
          onChanged: (value) {
            ref.read(cvProvider.notifier).updateEmail(value);
          },
        ),
        16.verticalSpace, // add contacts
        TextField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            icon: Icon(FontAwesome.location_arrow),
          ),
          onChanged: (value) {
            ref.read(cvProvider.notifier).updateAddress(value);
          },
        ),
        4.verticalSpace,
        const Divider(
          indent: 10,
          endIndent: 10,
        ),
        4.verticalSpace,
        //  profile
        TextField(
          controller: profileController,
          decoration: InputDecoration(
              labelText: 'Profile',
              helperText: 'summery of your cv as "${cv.profile}"'),
          onChanged: (value) {
            ref.read(cvProvider.notifier).updateJobTitle(value);
          },
          maxLines: 5,
          minLines: 3,
        ),
      ],
    );
  }

  Column skillsSection(context, skills) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Yours skills',
              style: GoogleFonts.tajawal(fontSize: 14.rs),
            ),
            const Expanded(
                child: Divider(
              indent: 10,
            )),
          ],
        ),
        4.verticalSpace,
        ListView.builder(
          itemCount: skills.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(skills[index]['skill']),
              subtitle: RatingBar(
                initialRating: double.parse(skills[index]['level'].toString()),
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                ignoreGestures: true,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.circle_rounded),
                  half: const Icon(Icons.circle_outlined),
                  empty: const Icon(Icons.circle_outlined),
                ),
                onRatingUpdate: (v) {},
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ref
                      .read(cvProvider.notifier)
                      .removeSkill(skills[index]['skill']);
                },
              ),
            );
          },
        ),
        12.verticalSpace,
        Row(
          children: [
            Text(
              'Add Skills',
              style: GoogleFonts.tajawal(fontSize: 14.rs),
            ),
            const Expanded(
                child: Divider(
              indent: 10,
            )),
          ],
        ),
        4.verticalSpace,
        Slider(
            value: selectedValueSkill,
            divisions: 5,
            min: 1,
            max: 5,
            label: '$selectedValueSkill',
            onChanged: (val) {
              setState(() {
                selectedValueSkill = val;
              });
            }),
        TextField(
          controller: skillController,
          decoration: InputDecoration(
              labelText: 'Add Soft skills',
              suffixIcon: IconButton(
                  onPressed: () {
                    if (skillController.text.isNotEmpty) {
                      ref.read(cvProvider.notifier).addSkill({
                        'skill': skillController.text,
                        'level': selectedValueSkill
                      });
                      skillController.clear();
                    }
                  },
                  icon: const Icon(Icons.add))),
          onChanged: (value) {
            // ref.read(cvProvider.notifier).updateName(value);
          },
        ),
      ],
    );
  }

  Column languagesSection(context, List<Map<String, dynamic>> langs) {
    GlobalKey<FormState> langFormKey = GlobalKey<FormState>();
    return Column(
      children: [
        ListView.builder(
          itemCount: langs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(langs[index]['lang']),
              subtitle: Text(range[langs[index]['level'] - 1]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ref
                      .read(cvProvider.notifier)
                      .removeLanguage(langs[index]['lang']);
                },
              ),
            );
          },
        ),
        12.verticalSpace,
        Form(
          key: langFormKey,
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedValuelang,
                  items: range
                      .map((level) => DropdownMenuItem<int>(
                            value: range.indexOf(level),
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (val) {
                    selectedValuelang = val;
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'level required!';
                    }
                    return null;
                  },
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: TextFormField(
                  controller: langController,
                  decoration: InputDecoration(
                    labelText: 'Add Language',
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (langFormKey.currentState!.validate()) {
                          ref.read(cvProvider.notifier).addlanguage({
                            'lang': langController.text,
                            'level': selectedValuelang
                          });
                          langController.clear();
                          selectedValuelang = null;
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  validator: Validatorless.required('languages required!'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget educationSection(context, List<Map<String, String>> educations) {
    final List<String> degrees = [
      'Associate Degree',
      'Bachelor\'s Degree',
      'Master\'s Degree',
      "Doctoral Degree"
    ];
    GlobalKey<FormState> eduFormKey = GlobalKey<FormState>();
    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
    // deg droplist

    // uni text

    // date datepiker
    // department text
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: educations.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  '${educations[index]['deg']!} in ${educations[index]['title']!}'),
              subtitle: Text(
                  'from ${educations[index]['uni']} on ${educations[index]['date']}'),
              trailing: IconButton(
                  onPressed: () {
                    ref
                        .read(cvProvider.notifier)
                        .removeDegree(educations[index]['uni']!);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            );
          },
        ),
        12.verticalSpace,
        const Text('Add a degree: '),
        12.verticalSpace,
        Form(
            key: eduFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: uniController,
                  decoration: const InputDecoration(
                    labelText: 'University Name',
                  ),
                  validator:
                      Validatorless.required('this section is required!'),
                ),
                12.verticalSpace,
                TextFormField(
                  controller: depController,
                  decoration: const InputDecoration(
                    labelText: 'Department Name',
                  ),
                  validator:
                      Validatorless.required('this section is required!'),
                ),
                // educations
                16.verticalSpace,
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Degree', // نص التسمية
                    border: OutlineInputBorder(),
                  ),
                  value: selectedValueEdu,
                  items: degrees
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (deg) {
                    setState(() {
                      selectedValueEdu = deg;
                    });
                  },
                  validator: Validatorless.required('degree is required!'),
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 25),
                          lastDate: DateTime(DateTime.now().year + 25),
                          initialDatePickerMode: DatePickerMode.year,
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              startDateEdu = date.year.toString();
                            });
                          }
                        });
                      },
                      child:
                          Text('Start : ${startDateEdu ?? 'click to select'}'),
                    ),
                    // Text(startDate ?? ''),
                    TextButton(
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 25),
                          lastDate: DateTime(DateTime.now().year + 25),
                          initialDatePickerMode: DatePickerMode.year,
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              endDateEdu = date.year.toString();
                            });
                          }
                        });
                      },
                      child:
                          Text('Graduate: ${endDateEdu ?? 'click to select'}'),
                    ),
                  ],
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        if (eduFormKey.currentState!.validate() &&
                            startDateEdu != null &&
                            endDateEdu != null) {
                          ref.read(cvProvider.notifier).addDegree({
                            'deg': selectedValueEdu!,
                            'title': depController.text,
                            'uni': uniController.text,
                            'date': '$startDateEdu - $endDateEdu'
                          });
                        }
                        if (startDateEdu == null || endDateEdu == null) {
                        } else {
                          btnController.reset();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
                12.verticalSpace,
              ],
            )),
      ],
    );
  }

  Widget experiencesSection(context, List<Map<String, String>> experiences) {
    GlobalKey<FormState> expFormKey = GlobalKey<FormState>();
    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListView.builder(
          itemCount: experiences.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  '${experiences[index]['title']} at ${experiences[index]['at']}'),
              subtitle: Text(
                  '${experiences[index]['text']} - ${experiences[index]['date']}'),
              trailing: IconButton(
                  onPressed: () {
                    ref
                        .read(cvProvider.notifier)
                        .removeExperiences(experiences[index]['at']!);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            );
          },
        ),
        12.verticalSpace,
        const Text('Add a Experiences: '),
        12.verticalSpace,
        Form(
          key: expFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: expAtController,
                decoration: const InputDecoration(
                  labelText: 'Company',
                ),
                validator: Validatorless.required('this section is required!'),
              ),
              12.verticalSpace,
              TextFormField(
                controller: expTitleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title ',
                ),
                validator: Validatorless.required('this section is required!'),
              ),
              // educations
              16.verticalSpace,
              TextFormField(
                controller: expTextController,
                decoration: const InputDecoration(
                  labelText: 'summery',
                ),
                validator: Validatorless.required('this section is required!'),
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 25),
                        lastDate: DateTime(DateTime.now().year + 25),
                        initialDatePickerMode: DatePickerMode.year,
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            startDateExp =
                                '${date.month}-${date.year.toString()}';
                          });
                        }
                      });
                    },
                    child: Text('Start : ${startDateExp ?? 'click to select'}'),
                  ),
                  // Text(startDate ?? ''),
                  TextButton(
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 25),
                        lastDate: DateTime(DateTime.now().year + 25),
                        initialDatePickerMode: DatePickerMode.year,
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            endDateExp =
                                '${date.month}-${date.year.toString()}';
                          });
                        }
                      });
                    },
                    child: Text('end: ${endDateExp ?? 'Now'}'),
                  ),
                ],
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (expFormKey.currentState!.validate() &&
                          startDateExp != null) {
                        ref.read(cvProvider.notifier).addExperiences({
                          'at': expAtController.text,
                          'title': expTitleController.text,
                          'text': expTextController.text,
                          'date': '$startDateExp- ${endDateExp ?? 'unitl now!'}'
                        });
                        expAtController.clear();
                        expTitleController.clear();
                        expTextController.clear();
                        startDateExp = null;
                        endDateExp = null;
                      }
                      if (startDateExp == null) {
                        btnController.reset();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              12.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }

  Widget profileImage(context, image) {
    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
    return Center(
      child: SizedBox(
        height: 200.rs,
        width: 200.rs,
        child: Stack(
          textDirection: TextDirection.ltr,
          children: [
            Positioned(
              child: CircleAvatar(
                radius: double.infinity.rh,
                backgroundImage: NetworkImage(
                  image ?? 'https://placehold.co/600x400/png',
                ),
              ),
            ),
            Positioned(
              bottom: 20.rh,
              right: 8.rh,
              child: ElevatedButton(
                onPressed: () async {
                  final ImagePickerPlugin picker = ImagePickerPlugin();
                  final image = await picker.getImageFromSource(
                      source: ImageSource.camera);
                  if (image?.path != null) {
                    ref
                        .read(cvProvider.notifier)
                        .updateProfileImage(image!.path);
                    btnController.success();
                  } else {
                    btnController.error();
                  }
                  Future.delayed(const Duration(seconds: 1))
                      .then((c) => btnController.reset());
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(const CircleBorder()),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  backgroundColor:
                      WidgetStateProperty.all(Colors.blue), // <-- Button color
                  overlayColor:
                      WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.red; // <-- Splash color
                    }
                    return null;
                  }),
                ),
                child: const Icon(Icons.edit),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column certificationSection(context, certification) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListView.builder(
          itemCount: certification.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              isThreeLine: true,
              title: Text('${certification[index]['title']}'),
              subtitle: Text('From: ${certification[index]['from']} '),
              trailing: IconButton(
                  onPressed: () {
                    ref
                        .read(cvProvider.notifier)
                        .removeECertification(certification[index]['title']!);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            );
          },
        ),
        12.verticalSpace,
        const Text('Add a Certification: '),
        12.verticalSpace,
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cerTitleController,
                decoration: const InputDecoration(
                  labelText: 'Certification Title',
                ),
                validator: Validatorless.required('this section is required!'),
              ),

              // educations
              16.verticalSpace,
              TextFormField(
                controller: cerFromController,
                decoration: const InputDecoration(
                  labelText: 'Certification issued from',
                ),
                validator: Validatorless.required('this section is required!'),
              ),

              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    // controller: btnController,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ref.read(cvProvider.notifier).addCertification({
                          'title': cerTitleController.text,
                          'from': cerFromController.text,
                        });

                        cerFromController.clear();
                        cerTitleController.clear();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              12.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }

  Column hobbiesSection(context, hobies) {
    return Column(
      children: [
        ListView.builder(
          itemCount: hobies.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(hobies[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ref.read(cvProvider.notifier).removeHobbies(hobies[index]);
                },
              ),
            );
          },
        ),
        TextField(
          controller: hobiesFromController,
          decoration: InputDecoration(
              labelText: 'Add hobies',
              suffixIcon: IconButton(
                  onPressed: () {
                    if (hobiesFromController.text.isNotEmpty) {
                      ref
                          .read(cvProvider.notifier)
                          .addHobbies(hobiesFromController.text);
                      hobiesFromController.clear();
                    }
                  },
                  icon: const Icon(Icons.add))),
        ),
      ],
    );
  }

  Column socialSection(context, List<Map<String, dynamic>> contacts) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    List<IconData> icons = [
      FontAwesome.youtube,
      FontAwesome.github,
      FontAwesome.google,
      FontAwesome.facebook,
      FontAwesome.linkedin,
      FontAwesome.twitter,
      FontAwesome.xing,
      FontAwesome.instagram,
      FontAwesome.reddit,
      FontAwesome.telegram,
      FontAwesome.youtube,
    ];
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: ListTile(
                    leading: Icon(contacts[index]['platform']),
                    title: Text(contacts[index]['username']),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(cvProvider.notifier)
                            .removeSocial(contacts[index]['platform']);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )),
              );
            }),
        10.verticalSpace,
        // add contacts
        Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<IconData>(
                  decoration: const InputDecoration(
                    labelText: 'Platform', // نص التسمية
                    border: OutlineInputBorder(),
                  ),
                  value: selectedValueSocial,
                  items: icons
                      .map((item) => DropdownMenuItem<IconData>(
                            value: item,
                            child: Center(child: Icon(item)),
                          ))
                      .toList(),
                  onChanged: (icon) {
                    setState(() {
                      selectedValueSocial = icon;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ),
              12.horizontalSpace,
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: socialFromController,
                  decoration: InputDecoration(
                      helperText: 'add @ to username or # as insta: @username',
                      labelText: 'username',
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                selectedValueSocial != null) {
                              ref.read(cvProvider.notifier).addSocial({
                                'platform': selectedValueSocial,
                                'username': socialFromController.text
                              });
                            }
                          },
                          icon: const Icon(Icons.add))),
                  validator: Validatorless.required('username required!'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
