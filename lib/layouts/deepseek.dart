import 'package:dot_cv_creator/layouts/input.dart' as c;
import 'package:dot_cv_creator/models/cv_modal.dart';
import 'package:dot_cv_creator/providers/statenotifier.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:validatorless/validatorless.dart';

final cvProvider =
    StateNotifierProvider<CvNotifier, CvModal>((ref) => CvNotifier());

class FormPage extends ConsumerStatefulWidget {
  const FormPage({super.key});

  @override
  ConsumerState<FormPage> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  @override
  Widget build(BuildContext context) {
    final cv = ref.watch(cvProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Builder'),
        actions: [
          if (MediaQuery.of(context).size.width < 768)
            TextButton(
              onPressed: () {
                Flexify.go(const c.CvFormScreenTest());
              },
              child: const Text('Preview'),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 768) {
            return FormSection(cv: cv, ref: ref);
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FormSection(cv: cv, ref: ref),
                ),
                Expanded(
                  flex: 3,
                  child: PreviewSection(cv: cv),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class FormSection extends StatefulWidget {
  final CvModal cv;
  final WidgetRef ref;

  const FormSection({super.key, required this.cv, required this.ref});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  late TextEditingController nameController;

  late TextEditingController profileController;

  late TextEditingController jobTitleController;

  late TextEditingController profileImageController;

  late TextEditingController softSkillController;

  late TextEditingController contactController;

  late TextEditingController profSkillController;

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

  String? selectedValueEdu;

  String? selectedValuelang;

  IconData? selectedValueContact;

  IconData? selectedValueSocial;

  String? startDateEdu;

  String? startDateExp;

  String? endDateEdu;

  String? endDateExp;

  @override
  void initState() {
    super.initState();
    final cv = widget.ref.read(cvProvider);
    nameController = TextEditingController(text: cv.name);
    profileController = TextEditingController(text: cv.profile);
    jobTitleController = TextEditingController(text: cv.jobTitle);
    profileImageController = TextEditingController(text: cv.profileImage);
    softSkillController = TextEditingController();
    profSkillController = TextEditingController();
    contactController = TextEditingController();
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
    softSkillController.dispose();
    contactController.dispose();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Identify Informations'),
          const Divider(),
          identifySection(context, widget.cv),
          25.verticalSpace,
          const Text('Profile Image Select'),
          const Divider(),
          profileImage(context, widget.cv.profileImage),
          25.verticalSpace,
          const Text('Contacts Information'),
          const Divider(),
          // contactSection(context, widget.cv.contacts),
          25.verticalSpace,
          const Divider(),
          const Text('Soft Skills'),
          skillsSection(context, widget.cv.skills),
          25.verticalSpace,
          const Text('Languages'),
          const Divider(),
          languagesSection(context, widget.cv.langauges),
          25.verticalSpace,
          const Text('Educations'),
          const Divider(),
          addEducation(context, widget.cv.educations),
          25.verticalSpace,
          const Text('Experiences'),
          const Divider(),
          addExperiences(context, widget.cv.experiences),
          25.verticalSpace,
          const Text('Certifications'),
          const Divider(),
          certificationSection(context, widget.cv.certifications),
          const Text('Hobbies'),
          const Divider(),
          hobbiesSection(context, widget.cv.hobbies),
          const Text('Social'),
          const Divider(),
          socialSection(context, widget.cv.socials),
        ],
      ),
    );
  }

  Column identifySection(BuildContext context, CvModal cv) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          onChanged: (value) {
            widget.ref.read(cvProvider.notifier).updateName(value);
          },
        ),
        16.verticalSpace,
        TextField(
          controller: jobTitleController,
          decoration: const InputDecoration(labelText: 'Job Title'),
          onChanged: (value) {
            widget.ref.read(cvProvider.notifier).updateJobTitle(value);
          },
        ),
        16.verticalSpace,
        TextField(
          controller: profileController,
          decoration: InputDecoration(
              labelText: 'Profile',
              helperText: 'summary of your cv as "${cv.profile}"'),
          onChanged: (value) {
            widget.ref.read(cvProvider.notifier).updateProfile(value);
          },
          maxLines: 5,
          minLines: 3,
        ),
      ],
    );
  }

  Column skillsSection(
      BuildContext context, List<Map<String, dynamic>> softSkills) {
    return Column(
      children: [
        ListView.builder(
          itemCount: softSkills.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(softSkills[index]['skill']),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  widget.ref
                      .read(cvProvider.notifier)
                      .removeSkill(softSkills[index]['skill']);
                },
              ),
            );
          },
        ),
        TextField(
          controller: softSkillController,
          decoration: InputDecoration(
              labelText: 'Add Soft skills',
              suffixIcon: IconButton(
                  onPressed: () {
                    if (softSkillController.text.isNotEmpty) {
                      widget.ref
                          .read(cvProvider.notifier)
                          .addSkill({'': softSkillController.text});
                      softSkillController.clear();
                    }
                  },
                  icon: const Icon(Icons.add))),
        ),
      ],
    );
  }

  Column languagesSection(
      BuildContext context, List<Map<String, dynamic>> langs) {
    GlobalKey<FormState> langFormKey = GlobalKey<FormState>();
    return Column(
      children: [
        ListView.builder(
          itemCount: langs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(langs[index]['lang']),
              subtitle: Text(langs[index]['level']),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  widget.ref
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
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedValuelang,
                  items: [
                    'Beginner',
                    'Proficient',
                    'Fluent',
                    'Conversational',
                    'Native',
                    'Intermediate',
                  ]
                      .map((level) => DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedValuelang = val;
                    });
                  },
                  validator: Validatorless.required('level required!'),
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
                        if (langFormKey.currentState!.validate() &&
                            selectedValuelang != null) {
                          widget.ref.read(cvProvider.notifier).addlanguage({
                            'lang': langController.text,
                            'level': selectedValuelang
                          });
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

  Widget addEducation(
      BuildContext context, List<Map<String, String>> educations) {
    final List<String> degrees = [
      'Associate Degree',
      'Bachelor\'s Degree',
      'Master\'s Degree',
      "Doctoral Degree"
    ];
    GlobalKey<FormState> eduFormKey = GlobalKey<FormState>();
    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
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
                    widget.ref
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
                16.verticalSpace,
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Degree',
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
                          widget.ref.read(cvProvider.notifier).addDegree({
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

  Widget addExperiences(
      BuildContext context, List<Map<String, String>> experiences) {
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
                    widget.ref
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
              16.verticalSpace,
              TextFormField(
                controller: expTextController,
                decoration: const InputDecoration(
                  labelText: 'summary',
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
                        widget.ref.read(cvProvider.notifier).addExperiences({
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

  Widget profileImage(BuildContext context, String? image) {
    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
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
                        widget.ref
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
                      padding:
                          WidgetStateProperty.all(const EdgeInsets.all(20)),
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      overlayColor:
                          WidgetStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.red;
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
        ],
      ),
    );
  }

  Column certificationSection(
      BuildContext context, List<Map<String, dynamic>> certification) {
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
                    widget.ref
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        widget.ref.read(cvProvider.notifier).addCertification({
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

  Column hobbiesSection(BuildContext context, List<String> hobies) {
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
                  widget.ref
                      .read(cvProvider.notifier)
                      .removeHobbies(hobies[index]);
                },
              ),
            );
          },
        ),
        TextField(
          controller: hobiesFromController,
          decoration: InputDecoration(
              labelText: 'Add hobbies',
              suffixIcon: IconButton(
                  onPressed: () {
                    if (hobiesFromController.text.isNotEmpty) {
                      widget.ref
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

  Column socialSection(
      BuildContext context, List<Map<String, dynamic>> contacts) {
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
                        widget.ref
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
        Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<IconData>(
                  decoration: const InputDecoration(
                    labelText: 'Platform',
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
                              widget.ref.read(cvProvider.notifier).addSocial({
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

class PreviewSection extends StatelessWidget {
  final CvModal cv;

  const PreviewSection({super.key, required this.cv});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add your preview widgets here...
        ],
      ),
    );
  }
}
