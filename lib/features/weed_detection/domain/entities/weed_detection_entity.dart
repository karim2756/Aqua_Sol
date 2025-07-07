import 'dart:io';

class WeedDetectionEntity {
  final String label;
  final String scientificName;
  final String description;
  final File? imageFile;

  const WeedDetectionEntity({
    required this.label,
    required this.scientificName,
    required this.description,
    this.imageFile,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WeedDetectionEntity &&
              runtimeType == other.runtimeType &&
              label == other.label &&
              scientificName == other.scientificName &&
              description == other.description;

  @override
  int get hashCode => label.hashCode ^ scientificName.hashCode ^ description.hashCode;
}