import 'package:flutter/material.dart';
//

class CvModal {
  CvModal({
    required this.name,
    required this.jobTitle,
    this.profileImage,
    required this.profile,
    required this.phone,
    required this.email,
    required this.address,
    required this.skills,
    required this.langauges,
    required this.educations,
    required this.experiences,
    required this.certifications,
    required this.hobbies,
    required this.socials,
    this.cvLanguages = TextDirection.ltr,
  });

  String name;
  String jobTitle;
  String? profileImage;
  String profile;
  String phone;
  String email;
  String address;
  List<Map<String, dynamic>> skills;

  List<Map<String, dynamic>> langauges; // لغة مع مستواها
  List<Map<String, String>> educations;
  List<Map<String, String>> experiences;
  List<Map<String, String>> certifications;
  List<String> hobbies;
  List<Map<String, dynamic>> socials;

  TextDirection cvLanguages;

  // **نسخ الكائن لتحديث البيانات**
  CvModal copyWith({
    String? name,
    String? jobTitle,
    String? profileImage,
    String? profile,
    String? phone,
    String? email,
    String? address,
    TextDirection? cvLanguages,
    //List<String>? skills,
    List<Map<String, dynamic>>? skills,
    List<Map<String, int>>? langauges,
    List<Map<String, String>>? educations,
    List<Map<String, String>>? experiences,
    List<Map<String, String>>? certifications,
    List<String>? hobies,
    List<Map<String, dynamic>>? socials,
  }) {
    return CvModal(
        name: name ?? this.name,
        jobTitle: jobTitle ?? this.jobTitle,
        profileImage: profileImage ?? this.profileImage,
        profile: profile ?? this.profile,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        skills: skills ?? this.skills,
        langauges: langauges ?? this.langauges,
        educations: educations ?? this.educations,
        experiences: experiences ?? this.experiences,
        certifications: certifications ?? this.certifications,
        hobbies: hobies ?? hobbies,
        socials: socials ?? this.socials,
        cvLanguages: cvLanguages ?? this.cvLanguages);
  }

  // **إضافة وحذف اللغات**
  void addLanguage(Map<String, dynamic> language) {
    langauges.add(language);
  }

  void removeLanguage(String languageName) {
    langauges.removeWhere((lang) => lang.containsKey(languageName));
  }

  // **إضافة وحذف المهارات اللينة**
  void addSkill(Map<String, dynamic> skill) {
    skills.add(skill);
  }

  void removeSkill(String skill) {
    skills.removeWhere((skillMap) => skillMap.containsValue(skill));
  }

  // **إضافة وحذف المهارات المهنية**

  // **إضافة وحذف التعليم**
  void addEducation(Map<String, String> education) {
    educations.add(education);
  }

  void removeEducation(String institutionName) {
    educations.removeWhere((edu) => edu["uni"] == institutionName);
  }

  // **إضافة وحذف الخبرات**
  void addExperience(Map<String, String> experience) {
    experiences.add(experience);
  }

  void removeExperience(String companyName) {
    experiences.removeWhere((exp) => exp["at"] == companyName);
  }

  // **إضافة وحذف الشهادات**
  void addCertification(Map<String, String> certification) {
    certifications.add(certification);
  }

  void removeCertification(String certificationName) {
    certifications.removeWhere((cert) => cert["title"] == certificationName);
  }

  // **إضافة وحذف الهوايات**
  void addHobby(String hobby) {
    hobbies.add(hobby);
  }

  void removeHobby(String hobbyName) {
    hobbies.removeWhere((hobby) => hobby == hobbyName);
  }

  // **إضافة وحذف مواقع التواصل**
  void addSocial(Map<String, dynamic> social) {
    socials.add(social);
  }

  void removeSocial(IconData platformName) {
    socials.removeWhere((social) => social["platform"] == platformName);
  }
}
