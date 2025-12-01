// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plogging_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PloggingStats {

 int get totalSessions; int get totalDurationMinutes; double get totalDistanceMeters; int get totalVerifications; int get totalPointsEarned; double get avgIntensityLevel;
/// Create a copy of PloggingStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PloggingStatsCopyWith<PloggingStats> get copyWith => _$PloggingStatsCopyWithImpl<PloggingStats>(this as PloggingStats, _$identity);

  /// Serializes this PloggingStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PloggingStats&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalDurationMinutes, totalDurationMinutes) || other.totalDurationMinutes == totalDurationMinutes)&&(identical(other.totalDistanceMeters, totalDistanceMeters) || other.totalDistanceMeters == totalDistanceMeters)&&(identical(other.totalVerifications, totalVerifications) || other.totalVerifications == totalVerifications)&&(identical(other.totalPointsEarned, totalPointsEarned) || other.totalPointsEarned == totalPointsEarned)&&(identical(other.avgIntensityLevel, avgIntensityLevel) || other.avgIntensityLevel == avgIntensityLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSessions,totalDurationMinutes,totalDistanceMeters,totalVerifications,totalPointsEarned,avgIntensityLevel);

@override
String toString() {
  return 'PloggingStats(totalSessions: $totalSessions, totalDurationMinutes: $totalDurationMinutes, totalDistanceMeters: $totalDistanceMeters, totalVerifications: $totalVerifications, totalPointsEarned: $totalPointsEarned, avgIntensityLevel: $avgIntensityLevel)';
}


}

/// @nodoc
abstract mixin class $PloggingStatsCopyWith<$Res>  {
  factory $PloggingStatsCopyWith(PloggingStats value, $Res Function(PloggingStats) _then) = _$PloggingStatsCopyWithImpl;
@useResult
$Res call({
 int totalSessions, int totalDurationMinutes, double totalDistanceMeters, int totalVerifications, int totalPointsEarned, double avgIntensityLevel
});




}
/// @nodoc
class _$PloggingStatsCopyWithImpl<$Res>
    implements $PloggingStatsCopyWith<$Res> {
  _$PloggingStatsCopyWithImpl(this._self, this._then);

  final PloggingStats _self;
  final $Res Function(PloggingStats) _then;

/// Create a copy of PloggingStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSessions = null,Object? totalDurationMinutes = null,Object? totalDistanceMeters = null,Object? totalVerifications = null,Object? totalPointsEarned = null,Object? avgIntensityLevel = null,}) {
  return _then(_self.copyWith(
totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,totalDurationMinutes: null == totalDurationMinutes ? _self.totalDurationMinutes : totalDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,totalDistanceMeters: null == totalDistanceMeters ? _self.totalDistanceMeters : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
as double,totalVerifications: null == totalVerifications ? _self.totalVerifications : totalVerifications // ignore: cast_nullable_to_non_nullable
as int,totalPointsEarned: null == totalPointsEarned ? _self.totalPointsEarned : totalPointsEarned // ignore: cast_nullable_to_non_nullable
as int,avgIntensityLevel: null == avgIntensityLevel ? _self.avgIntensityLevel : avgIntensityLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PloggingStats].
extension PloggingStatsPatterns on PloggingStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PloggingStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PloggingStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PloggingStats value)  $default,){
final _that = this;
switch (_that) {
case _PloggingStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PloggingStats value)?  $default,){
final _that = this;
switch (_that) {
case _PloggingStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalSessions,  int totalDurationMinutes,  double totalDistanceMeters,  int totalVerifications,  int totalPointsEarned,  double avgIntensityLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PloggingStats() when $default != null:
return $default(_that.totalSessions,_that.totalDurationMinutes,_that.totalDistanceMeters,_that.totalVerifications,_that.totalPointsEarned,_that.avgIntensityLevel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalSessions,  int totalDurationMinutes,  double totalDistanceMeters,  int totalVerifications,  int totalPointsEarned,  double avgIntensityLevel)  $default,) {final _that = this;
switch (_that) {
case _PloggingStats():
return $default(_that.totalSessions,_that.totalDurationMinutes,_that.totalDistanceMeters,_that.totalVerifications,_that.totalPointsEarned,_that.avgIntensityLevel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalSessions,  int totalDurationMinutes,  double totalDistanceMeters,  int totalVerifications,  int totalPointsEarned,  double avgIntensityLevel)?  $default,) {final _that = this;
switch (_that) {
case _PloggingStats() when $default != null:
return $default(_that.totalSessions,_that.totalDurationMinutes,_that.totalDistanceMeters,_that.totalVerifications,_that.totalPointsEarned,_that.avgIntensityLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PloggingStats implements PloggingStats {
  const _PloggingStats({this.totalSessions = 0, this.totalDurationMinutes = 0, this.totalDistanceMeters = 0.0, this.totalVerifications = 0, this.totalPointsEarned = 0, this.avgIntensityLevel = 1.0});
  factory _PloggingStats.fromJson(Map<String, dynamic> json) => _$PloggingStatsFromJson(json);

@override@JsonKey() final  int totalSessions;
@override@JsonKey() final  int totalDurationMinutes;
@override@JsonKey() final  double totalDistanceMeters;
@override@JsonKey() final  int totalVerifications;
@override@JsonKey() final  int totalPointsEarned;
@override@JsonKey() final  double avgIntensityLevel;

/// Create a copy of PloggingStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PloggingStatsCopyWith<_PloggingStats> get copyWith => __$PloggingStatsCopyWithImpl<_PloggingStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PloggingStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PloggingStats&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalDurationMinutes, totalDurationMinutes) || other.totalDurationMinutes == totalDurationMinutes)&&(identical(other.totalDistanceMeters, totalDistanceMeters) || other.totalDistanceMeters == totalDistanceMeters)&&(identical(other.totalVerifications, totalVerifications) || other.totalVerifications == totalVerifications)&&(identical(other.totalPointsEarned, totalPointsEarned) || other.totalPointsEarned == totalPointsEarned)&&(identical(other.avgIntensityLevel, avgIntensityLevel) || other.avgIntensityLevel == avgIntensityLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSessions,totalDurationMinutes,totalDistanceMeters,totalVerifications,totalPointsEarned,avgIntensityLevel);

@override
String toString() {
  return 'PloggingStats(totalSessions: $totalSessions, totalDurationMinutes: $totalDurationMinutes, totalDistanceMeters: $totalDistanceMeters, totalVerifications: $totalVerifications, totalPointsEarned: $totalPointsEarned, avgIntensityLevel: $avgIntensityLevel)';
}


}

/// @nodoc
abstract mixin class _$PloggingStatsCopyWith<$Res> implements $PloggingStatsCopyWith<$Res> {
  factory _$PloggingStatsCopyWith(_PloggingStats value, $Res Function(_PloggingStats) _then) = __$PloggingStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalSessions, int totalDurationMinutes, double totalDistanceMeters, int totalVerifications, int totalPointsEarned, double avgIntensityLevel
});




}
/// @nodoc
class __$PloggingStatsCopyWithImpl<$Res>
    implements _$PloggingStatsCopyWith<$Res> {
  __$PloggingStatsCopyWithImpl(this._self, this._then);

  final _PloggingStats _self;
  final $Res Function(_PloggingStats) _then;

/// Create a copy of PloggingStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSessions = null,Object? totalDurationMinutes = null,Object? totalDistanceMeters = null,Object? totalVerifications = null,Object? totalPointsEarned = null,Object? avgIntensityLevel = null,}) {
  return _then(_PloggingStats(
totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,totalDurationMinutes: null == totalDurationMinutes ? _self.totalDurationMinutes : totalDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,totalDistanceMeters: null == totalDistanceMeters ? _self.totalDistanceMeters : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
as double,totalVerifications: null == totalVerifications ? _self.totalVerifications : totalVerifications // ignore: cast_nullable_to_non_nullable
as int,totalPointsEarned: null == totalPointsEarned ? _self.totalPointsEarned : totalPointsEarned // ignore: cast_nullable_to_non_nullable
as int,avgIntensityLevel: null == avgIntensityLevel ? _self.avgIntensityLevel : avgIntensityLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
