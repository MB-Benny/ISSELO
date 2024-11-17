class FormStepsModel {
  final String title;
  final String label;
  FormStatus status;

  FormStepsModel({
    required this.title,
    required this.label,
    this.status = FormStatus.pending,
  });
}

enum FormStatus { completed, pending }
