import 'package:dot_cv_creator/models/cv_modal.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final cvProvider =
    StateNotifierProvider<CvNotifier, CvModal>((ref) => CvNotifier());

class CvNotifier extends StateNotifier<CvModal> {
  CvNotifier()
      : super(
          CvModal(
            name: '', // t
            jobTitle: '',
            profileImage: '',
            profile: '', phone: '',
            email: '',
            address: '',

            skills: [],

            langauges: [],
            educations: [],
            experiences: [],
            certifications: [],
            hobies: [],
            socials: [],
          ),
        );

  // update name
  void updateName(String data) {
    state = state.copyWith(name: data);
  }

  // update job title
  void updateJobTitle(String data) {
    state = state.copyWith(jobTitle: data);
  }

  //update ProfileImage
  void updateProfileImage(String data) {
    state = state.copyWith(profileImage: data);
  }

  //update Profile
  void updateProfile(String data) {
    state = state.copyWith(profile: data);
  }

  //update phone
  void updatePhone(String data) {
    state = state.copyWith(phone: data);
  }

  //update Email
  void updateEmail(String data) {
    state = state.copyWith(email: data);
  }

  //update adress
  void updateAddress(String data) {
    state = state.copyWith(address: data);
  }

  // add and remove soft skills
  void addSkill(Map<String, dynamic> data) {
    state.addSkill(data);
    state = state.copyWith();
  }

  void removeSkill(String data) {
    state.removeSkill(data);
    state = state.copyWith();
  }

  // add and remove languages
  void addlanguage(Map<String, dynamic> lang) {
    state.addLanguage(lang);
    state = state.copyWith();
  }

  void removeLanguage(String data) {
    state.langauges.removeWhere((lang) => lang['lang'] == data);
    state = state.copyWith();
  }

  void addDegree(Map<String, String> degree) {
    state.addEducation(degree);
    state = state.copyWith();
  }

  void removeDegree(String institutionName) {
    state.removeEducation(institutionName);
    state = state.copyWith();
  }

  void addExperiences(Map<String, String> experiences) {
    state.addExperience(experiences);
    state = state.copyWith();
  }

  void removeExperiences(String at) {
    state.removeExperience(at);
    state = state.copyWith();
  }

  void addCertification(Map<String, String> certification) {
    state.addCertification(certification);
    state = state.copyWith();
  }

  void removeECertification(String title) {
    state.removeCertification(title);
    state = state.copyWith();
  }

  void addHobbies(String data) {
    state.addHobby(data);
    state = state.copyWith();
  }

  void removeHobbies(String data) {
    state.removeHobby(data);
    state = state.copyWith();
  }

  void addSocial(Map<String, dynamic> data) {
    state.addSocial(data);
    state = state.copyWith();
  }

  void removeSocial(IconData key) {
    state.removeSocial(key);
    state = state.copyWith();
  }
}
/*
 name: 'AbdulRasol Al-Hilo', // t
            jobTitle: 'IT & Engineer',
            profileImage:
                'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
            profile:
                'Natus et aliquid at maiores asperiores. Eos blanditiis omnis voluptas distinctio ut repudiandae cumque soluta consectetur. Non ex unde sit. Possimus aspernatur quos pariatur ut nihil dolorem voluptatum necessitatibus voluptatem. Consequatur saepe repudiandae maxime ducimus eveniet ipsum dolorum quam alias.',
            phone: '07813639721',
            email: 'abdulrsol97@gmail.com',
            address: 'Najaf, Iraq',

            skills: [
              {'skill': 'Good in and Communications', 'level': 4},
              {'skill': 'Flutter/Dart', 'level': 4},
              {'skill': 'Python', 'level': 3},
              {'skill': 'Python', 'level': 3},
            ],

            langauges: [
              {'lang': 'Arabic', 'level': 5},
              {'lang': 'English', 'level': 3},
            ],
            educations: [
              {
                'deg': 'Bclorus',
                'title': 'Mechanical Engineering',
                'uni': 'Al-Furat Al-Awsat - collage of engineering',
                'date': '2015 - 2019'
              }
            ],
            experiences: [
              {
                'at': 'Dot.tech',
                'text': 'Fugit repudiandae harum suscipit et et.',
                'date': '08-2019-now',
                'title': 'founder',
              },
              {
                'at': 'Alshimaa',
                'title': 'data entry',
                'text': 'متع اكره عن متى نقود عليه وسوف.',
                'date': 'from 03-2017 to 03-2020',
              }
            ],
            certifications: [
              {
                'title': 'Basic English',
                'from': 'FutureLearn',
                'date': 'nov 2019',
              }
            ],
            hobies: [
              'Travel',
              'Reading',
              'Exploration',
            ],
            socials: [
              {'platform': FontAwesome.github, 'username': 'abdulrasol'},
              {'platform': FontAwesome.instagram, 'username': 'abdulrasol'},
              {'platform': FontAwesome.facebook, 'username': 'abdulrasol'},
              {'platform': FontAwesome.twitter, 'username': 'abdulrasol'},
            ],
*/
