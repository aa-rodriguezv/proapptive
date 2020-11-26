import 'package:flutter/material.dart';

class Award {
  final String name;
  final String description;
  final String imagePath;
  final double requiredPoints;

  Award({
    @required this.name,
    @required this.description,
    @required this.imagePath,
    @required this.requiredPoints,
  });

  static final List<Award> awardDummies = [
    Award(
      name: 'Día Libre',
      description: 'Redime un día libre para descansar entre semana.',
      imagePath: 'assets/images/free.jpg',
      requiredPoints: 2000,
    ),
    Award(
      name: 'Bono Kokoriko',
      description: '15% de descuento para tu próximo pedido.',
      imagePath: 'assets/images/kokorico.jpg',
      requiredPoints: 5000,
    ),
    Award(
      name: 'Descuento Bodytech',
      description: '10% de descuento para el próximo mes de suscripción.',
      imagePath: 'assets/images/bodytech.png',
      requiredPoints: 3000,
    ),
    Award(
      name: 'Bono Pan Pa\' Ya!',
      description: '20% de descuento en almuerzos seleccionados.',
      imagePath: 'assets/images/panpaya.png',
      requiredPoints: 10000,
    ),
  ];
}
