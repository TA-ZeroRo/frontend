class ChartData {
  final DateTime date;
  final int score;

  const ChartData({required this.date, required this.score});

  ChartData copyWith({DateTime? date, int? score}) {
    return ChartData(date: date ?? this.date, score: score ?? this.score);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartData && other.date == date && other.score == score;
  }

  @override
  int get hashCode => Object.hash(date, score);

  @override
  String toString() => 'ChartData(date: $date, score: $score)';
}
