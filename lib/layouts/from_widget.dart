import 'package:dot_cv_creator/models/cv_modal.dart';
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
import '../providers/statenotifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FromWidget extends ConsumerStatefulWidget {
  const FromWidget({super.key});

  @override
  ConsumerState<FromWidget> createState() => _FromWidgetState();
}

class _FromWidgetState extends ConsumerState<FromWidget> {
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
  late CvModal cv;

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

  @override
  void initState() {
    super.initState();
    cv = ref.read(cvProvider);
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
  Widget build(BuildContext context) {
    final cv = ref.watch(cvProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اختيار اللغة

          ListTile(
            onTap: () {
              ref.read(cvProvider.notifier).changeLang(TextDirection.rtl);
            },
            title: const Text('لغة السيرة الذاتية عربية!'),
            leading: Radio<TextDirection>(
              value: TextDirection.rtl,
              groupValue: cv.cvLanguages,
              onChanged: (TextDirection? lang) {},
            ),
          ),
          ListTile(
            onTap: () {
              ref.read(cvProvider.notifier).changeLang(TextDirection.ltr);
            },
            title: const Text('Resume language is English!'),
            leading: Radio<TextDirection>(
              value: TextDirection.ltr,
              groupValue: cv.cvLanguages,
              onChanged: (TextDirection? lang) {},
            ),
          ),

          ExpansionPanelList(
            children: [
              accordingItem(
                  AppLocalizations.of(context)!.from_personal_details_label,
                  0,
                  identifySection(context, cv, cv.profileImage)),
              accordingItem(
                  AppLocalizations.of(context)!
                      .from__your_educational_background_label,
                  1,
                  educationSection(context, cv.educations)),
              accordingItem(
                  AppLocalizations.of(context)!
                      .from__highlight_your_strengths_label,
                  2,
                  skillsSection(context, cv.skills)),
              accordingItem(
                  AppLocalizations.of(context)!.from__career_highlights_label,
                  3,
                  experiencesSection(context, cv.experiences)),
              accordingItem(
                  AppLocalizations.of(context)!.from__languages_you_speak_label,
                  4,
                  languagesSection(context, cv.langauges)),
              accordingItem(
                  AppLocalizations.of(context)!
                      .from__certifications_training_label,
                  5,
                  certificationSection(context, cv.certifications)),
              accordingItem(
                  AppLocalizations.of(context)!.from__your_interests_label,
                  6,
                  hobbiesSection(context, cv.hobbies)),
              accordingItem(
                  AppLocalizations.of(context)!
                      .from__social_media_profiles_label,
                  7,
                  socialSection(context, cv.socials)),
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

  Column identifySection(context, CvModal cv, image) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              final ImagePickerPlugin picker = ImagePickerPlugin();
              final image =
                  await picker.getImageFromSource(source: ImageSource.gallery);
              if (image?.path != null) {
                ref.read(cvProvider.notifier).updateProfileImage(image!.path);
              }
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(const CircleBorder()),
              padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
              backgroundColor:
                  WidgetStateProperty.all(Colors.blue), // <-- Button color
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.red; // <-- Splash color
                }
                return null;
              }),
            ),
            child: CircleAvatar(
              radius: 50.rs,
              backgroundImage: cv.profileImage != ''
                  ? NetworkImage(image)
                  : const AssetImage('assets/images/avatar.png'),
            ),
          ),
        ),

        Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.from__name_label),
              onChanged: (value) {
                ref.read(cvProvider.notifier).updateName(value);
              },
            ),
            16.verticalSpace,
            // job title
            TextField(
              controller: jobTitleController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.from__job_title_label),
              onChanged: (value) {
                ref.read(cvProvider.notifier).updateJobTitle(value);
              },
            ),
            16.verticalSpace,
          ],
        ),
        4.verticalSpace,
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.howtoReachYou,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.from__phone_label,
            icon: const Icon(FontAwesome.phone),
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.from__email_label,
            icon: const Icon(FontAwesome.at),
          ),
          onChanged: (value) {
            // print(value);
            ref.read(cvProvider.notifier).updateEmail(value);
          },
        ),
        16.verticalSpace, // add contacts
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.from__address_label,
            icon: const Icon(FontAwesome.location_arrow),
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
            labelText: AppLocalizations.of(context)!.from__profile_label,
          ),
          onChanged: (value) {
            ref.read(cvProvider.notifier).updateProfile(value);
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
              AppLocalizations.of(context)!.skills,
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
              AppLocalizations.of(context)!.addSkills,
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
              labelText:
                  AppLocalizations.of(context)!.from__add_soft_skills_label,
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
    final List<String> range = [
      AppLocalizations.of(context)!.from__beginner_level,
      AppLocalizations.of(context)!.from__moderate_level,
      AppLocalizations.of(context)!.from__good_level,
      AppLocalizations.of(context)!.from__very_good_level,
      AppLocalizations.of(context)!.from__fluent_level,
    ];
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.from__level_label,
                    border: const OutlineInputBorder(),
                  ),
                  value: selectedValuelang,
                  items: range
                      .map((level) => DropdownMenuItem<int>(
                            value: range.indexOf(level) + 1,
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
                    labelText:
                        AppLocalizations.of(context)!.from__add_language_label,
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
      AppLocalizations.of(context)!.from__diploma_degree,
      AppLocalizations.of(context)!.from__bachelor_degree,
      AppLocalizations.of(context)!.from__master_degree,
      AppLocalizations.of(context)!.from__doctoral_degree,
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
              title: Text(AppLocalizations.of(context)!
                  .from__educations_deg_in_title(
                      educations[index]['deg']!, educations[index]['title']!)),
              //'${educations[index]['deg']!} in ${educations[index]['title']!}'),
              subtitle: Text(AppLocalizations.of(context)!
                  .from__educations_from_on_date(
                      educations[index]['uni']!, educations[index]['date']!)),
              //'from ${educations[index]['uni']} on ${educations[index]['date']}'),
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
        Text(AppLocalizations.of(context)!.addDegree),
        12.verticalSpace,
        Form(
            key: eduFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: uniController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.from__university_name,
                  ),
                  validator: Validatorless.required(
                      AppLocalizations.of(context)!
                          .from__this_section_is_required),
                ),
                12.verticalSpace,
                TextFormField(
                  controller: depController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.from__department_name,
                  ),
                  validator: Validatorless.required(
                      AppLocalizations.of(context)!
                          .from__this_section_is_required),
                ),
                // educations
                16.verticalSpace,
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .from__the_degree, // نص التسمية
                    border: const OutlineInputBorder(),
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
                  validator: Validatorless.required(
                      AppLocalizations.of(context)!
                          .from__this_section_is_required),
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
                      child: Text(AppLocalizations.of(context)!
                          .from__edu_started(startDateEdu ??
                              AppLocalizations.of(context)!
                                  .from__click_to_select)),
                    ),
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
                        child: Text(AppLocalizations.of(context)!.graduated(
                            endDateEdu ??
                                AppLocalizations.of(context)!
                                    .from__click_to_select))),
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
                      child: Text(AppLocalizations.of(context)!.addbuttonText),
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
              title: Text(AppLocalizations.of(context)!.experiences(
                  experiences[index]['title']!, experiences[index]['at']!)),
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
        Text(AppLocalizations.of(context)!.from__addExperiences),
        12.verticalSpace,
        Form(
          key: expFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: expAtController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.from__company_label,
                ),
                validator: Validatorless.required(AppLocalizations.of(context)!
                    .from__this_section_is_required),
              ),
              12.verticalSpace,
              TextFormField(
                controller: expTitleController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.from__job_title_label,
                ),
                validator: Validatorless.required(AppLocalizations.of(context)!
                    .from__this_section_is_required),
              ),
              // educations
              16.verticalSpace,
              TextFormField(
                controller: expTextController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.from__summery_label,
                ),
                validator: Validatorless.required(AppLocalizations.of(context)!
                    .from__this_section_is_required),
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
                    child: Text(AppLocalizations.of(context)!.from__ExpDate(
                        startDateExp ??
                            AppLocalizations.of(context)!
                                .from__click_to_select)),
                  ),
                  //
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
                    child: Text(AppLocalizations.of(context)!
                        .from__end_enddateexp_now(endDateExp ??
                            AppLocalizations.of(context)!
                                .from__click_to_select)),
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
                          'date':
                              '$startDateExp- ${endDateExp ?? AppLocalizations.of(context)!.from__unitl_now}'
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
                    child: Text(AppLocalizations.of(context)!.addbuttonText),
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
          textDirection: TextDirection.rtl,
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
              subtitle: Text(AppLocalizations.of(context)!
                  .from__from_certification_index_from(certification[index]
                      ['from'])), //'From: ${certification[index]['from']} '),
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
        Text(AppLocalizations.of(context)!.from__add_a_certification),
        12.verticalSpace,
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cerTitleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .from__certification_title_label,
                ),
                validator: Validatorless.required(AppLocalizations.of(context)!
                    .from__this_section_is_required),
              ),

              // educations
              16.verticalSpace,
              TextFormField(
                controller: cerFromController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .from__ertification_issued_from_label,
                ),
                validator: Validatorless.required(AppLocalizations.of(context)!
                    .from__this_section_is_required),
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
                    child: Text(AppLocalizations.of(context)!.addbuttonText),
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
              labelText: AppLocalizations.of(context)!.from__add_hobies_label,
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .from__platform_label, // نص التسمية
                    border: const OutlineInputBorder(),
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
                      helperText:
                          AppLocalizations.of(context)!.from__add_helper_text,
                      labelText:
                          AppLocalizations.of(context)!.from__username_label,
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
