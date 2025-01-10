import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// تعريف نموذج CvModal
class CvModal {
  CvModal({
    required this.name,
    required this.jobTitle,
    required this.profile,
    required this.softSkills,
  });

  String name;
  String jobTitle;
  String profile;
  List<String> softSkills;

  CvModal copyWith({
    String? name,
    String? jobTitle,
    String? profile,
    List<String>? softSkills,
  }) {
    return CvModal(
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      profile: profile ?? this.profile,
      softSkills: softSkills ?? this.softSkills,
    );
  }
}

// مزود Riverpod لإدارة CvModal
final cvProvider = StateNotifierProvider<CvNotifier, CvModal>((ref) {
  return CvNotifier();
});

class CvNotifier extends StateNotifier<CvModal> {
  CvNotifier()
      : super(
          CvModal(
            name: 'AbdulRasol',
            jobTitle: 'IT Engineer',
            profile: 'Write a short profile about yourself.',
            softSkills: ['Communication', 'Teamwork'],
          ),
        );

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateJobTitle(String value) {
    state = state.copyWith(jobTitle: value);
  }

  void updateProfile(String value) {
    state = state.copyWith(profile: value);
  }

  void addSoftSkill(String skill) {
    final updatedSkills = [...state.softSkills, skill];
    state = state.copyWith(softSkills: updatedSkills);
  }

  void removeSoftSkill(String skill) {
    final updatedSkills = state.softSkills.where((s) => s != skill).toList();
    state = state.copyWith(softSkills: updatedSkills);
  }
}

// واجهة إدخال المعلومات
class CvFormScreenTest extends ConsumerStatefulWidget {
  const CvFormScreenTest({super.key});

  @override
  ConsumerState<CvFormScreenTest> createState() => _CvFormScreenState();
}

class _CvFormScreenState extends ConsumerState<CvFormScreenTest> {
  late TextEditingController nameController;
  late TextEditingController jobTitleController;
  late TextEditingController profileController;

  @override
  void initState() {
    super.initState();
    final cv = ref.read(cvProvider);
    nameController = TextEditingController(text: cv.name);
    jobTitleController = TextEditingController(text: cv.jobTitle);
    profileController = TextEditingController(text: cv.profile);
  }

  @override
  void dispose() {
    nameController.dispose();
    jobTitleController.dispose();
    profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cv = ref.watch(cvProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit CV'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                ref.read(cvProvider.notifier).updateName(value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: jobTitleController,
              decoration: const InputDecoration(labelText: 'Job Title'),
              onChanged: (value) {
                ref.read(cvProvider.notifier).updateJobTitle(value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: profileController,
              decoration: const InputDecoration(labelText: 'Profile'),
              maxLines: 3,
              onChanged: (value) {
                ref.read(cvProvider.notifier).updateProfile(value);
              },
            ),
            const SizedBox(height: 16),
            _SkillsSection(
              title: 'Soft Skills',
              skills: cv.softSkills,
              onAdd: (skill) {
                ref.read(cvProvider.notifier).addSoftSkill(skill);
              },
              onRemove: (skill) {
                ref.read(cvProvider.notifier).removeSoftSkill(skill);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// قسم المهارات
class _SkillsSection extends StatelessWidget {
  final String title;
  final List<String> skills;
  final Function(String) onAdd;
  final Function(String) onRemove;

  const _SkillsSection({
    required this.title,
    required this.skills,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...skills.map(
          (skill) => ListTile(
            title: Text(skill),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemove(skill),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Add $title'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAdd(controller.text);
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: CvFormScreenTest(),
      ),
    ),
  );
}
