import 'package:flutter/material.dart';

class Achievement {
  final String name;
  final String description;
  final String imagePath;
  final String prizeDescription;

  Achievement({
    @required this.name,
    @required this.description,
    @required this.imagePath,
    @required this.prizeDescription,
  });

  static final List<Achievement> dummies = [
    Achievement(
      name: '',
      description: '',
      imagePath: '',
      prizeDescription: '',
    ),
    Achievement(
      name: '',
      description: '',
      imagePath: '',
      prizeDescription: '',
    ),
    Achievement(
      name: '',
      description: '',
      imagePath: '',
      prizeDescription: '',
    ),
    Achievement(
      name: '',
      description: '',
      imagePath: '',
      prizeDescription: '',
    ),
    Achievement(
      name: '',
      description: '',
      imagePath: '',
      prizeDescription: '',
    ),
    Achievement(
      name: '',
      description: '',
      imagePath: '',
      prizeDescription: '',
    ),
  ];
}
