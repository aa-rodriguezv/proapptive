import 'package:flutter/material.dart';

class Achievement {
  final String name;
  final String description;
  final String imagePath;
  final double gainPoints;

  Achievement({
    @required this.name,
    @required this.description,
    @required this.imagePath,
    @required this.gainPoints,
  });

  static final List<Achievement> achievementDummies = [
    Achievement(
      name: 'Racha',
      description:
          'Complentar 2 pasos de meta todos los días de la semana durante 2 semanas',
      imagePath: 'assets/images/streak.png',
      gainPoints: 100,
    ),
    Achievement(
      name: 'Ahorro',
      description:
          'Optimice los recursos de un proyecto para ahorrar el 20% de lo que hay que invertir',
      imagePath: 'assets/images/save.png',
      gainPoints: 1000,
    ),
    Achievement(
      name: 'Calidad',
      description:
          'Realice una actividad que sea reconocida como la mejor del departamento.',
      imagePath: 'assets/images/quality.png',
      gainPoints: 200,
    ),
    Achievement(
      name: 'Veloz',
      description: 'Realizar 3 pasos de meta en menos de 3 horas',
      imagePath: 'assets/images/speed.png',
      gainPoints: 50,
    ),
    Achievement(
      name: 'Eficiencia',
      description:
          'Entregue 4 pasos de meta 1 día antes de la fecha de entrega',
      imagePath: 'assets/images/efficiency.png',
      gainPoints: 500,
    ),
    Achievement(
      name: 'Tiempo Horario',
      description:
          'Mantenga su tiempo de trabajo por debajo de las 10 horas por 2 semanas consecutivas',
      imagePath: 'assets/images/time.png',
      gainPoints: 300,
    ),
  ];
}
