abstract class Exception {
  Exception({
    required this.source,
    this.message,
  });

  final String source;
  final String? message;
}
