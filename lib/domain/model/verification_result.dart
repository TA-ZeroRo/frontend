class VerificationResult {
  final bool isValid;
  final double confidence;
  final String reason;

  const VerificationResult({
    required this.isValid,
    required this.confidence,
    required this.reason,
  });
}
