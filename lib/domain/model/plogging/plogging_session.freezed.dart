// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plogging_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PloggingSession {

 int get id; String get userId; PloggingStatus get status; DateTime get startedAt; DateTime? get endedAt; int? get durationMinutes; double? get totalDistanceMeters; int get intensityLevel; int get verificationCount; int get pointsEarned; DateTime get createdAt;
/// Create a copy of PloggingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PloggingSessionCopyWith<PloggingSession> get copyWith => _$PloggingSessionCopyWithImpl<PloggingSession>(this as PloggingSession, _$identity);

  /// Serializes this PloggingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PloggingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.totalDistanceMeters, totalDistanceMeters) || other.totalDistanceMeters == totalDistanceMeters)&&(identical(other.intensityLevel, intensityLevel) || other.intensityLevel == intensityLevel)&&(identical(other.verificationCount, verificationCount) || other.verificationCount == verificationCount)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,status,startedAt,endedAt,durationMinutes,totalDistanceMeters,intensityLevel,verificationCount,pointsEarned,createdAt);

@override
String toString() {
  return 'PloggingSession(id: $id, userId: $userId, status: $status, startedAt: $startedAt, endedAt: $endedAt, durationMinutes: $durationMinutes, totalDistanceMeters: $totalDistanceMeters, intensityLevel: $intensityLevel, verificationCount: $verificationCount, pointsEarned: $pointsEarned, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PloggingSessionCopyWith<$Res>  {
  factory $PloggingSessionCopyWith(PloggingSession value, $Res Function(PloggingSession) _then) = _$PloggingSessionCopyWithImpl;
@useResult
$Res call({
 int id, String userId, PloggingStatus status, DateTime startedAt, DateTime? endedAt, int? durationMinutes, double? totalDistanceMeters, int intensityLevel, int verificationCount, int pointsEarned, DateTime createdAt
});




}
/// @nodoc
class _$PloggingSessionCopyWithImpl<$Res>
    implements $PloggingSessionCopyWith<$Res> {
  _$PloggingSessionCopyWithImpl(this._self, this._then);

  final PloggingSession _self;
  final $Res Function(PloggingSession) _then;

/// Create a copy of PloggingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? durationMinutes = freezed,Object? totalDistanceMeters = freezed,Object? intensityLevel = null,Object? verificationCount = null,Object? pointsEarned = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PloggingStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,totalDistanceMeters: freezed == totalDistanceMeters ? _self.totalDistanceMeters : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
as double?,intensityLevel: null == intensityLevel ? _self.intensityLevel : intensityLevel // ignore: cast_nullable_to_non_nullable
as int,verificationCount: null == verificationCount ? _self.verificationCount : verificationCount // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PloggingSession].
extension PloggingSessionPatterns on PloggingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PloggingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PloggingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PloggingSession value)  $default,){
final _that = this;
switch (_that) {
case _PloggingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PloggingSession value)?  $default,){
final _that = this;
switch (_that) {
case _PloggingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  PloggingStatus status,  DateTime startedAt,  DateTime? endedAt,  int? durationMinutes,  double? totalDistanceMeters,  int intensityLevel,  int verificationCount,  int pointsEarned,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PloggingSession() when $default != null:
return $default(_that.id,_that.userId,_that.status,_that.startedAt,_that.endedAt,_that.durationMinutes,_that.totalDistanceMeters,_that.intensityLevel,_that.verificationCount,_that.pointsEarned,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  PloggingStatus status,  DateTime startedAt,  DateTime? endedAt,  int? durationMinutes,  double? totalDistanceMeters,  int intensityLevel,  int verificationCount,  int pointsEarned,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PloggingSession():
return $default(_that.id,_that.userId,_that.status,_that.startedAt,_that.endedAt,_that.durationMinutes,_that.totalDistanceMeters,_that.intensityLevel,_that.verificationCount,_that.pointsEarned,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  PloggingStatus status,  DateTime startedAt,  DateTime? endedAt,  int? durationMinutes,  double? totalDistanceMeters,  int intensityLevel,  int verificationCount,  int pointsEarned,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PloggingSession() when $default != null:
return $default(_that.id,_that.userId,_that.status,_that.startedAt,_that.endedAt,_that.durationMinutes,_that.totalDistanceMeters,_that.intensityLevel,_that.verificationCount,_that.pointsEarned,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PloggingSession implements PloggingSession {
  const _PloggingSession({required this.id, required this.userId, required this.status, required this.startedAt, this.endedAt, this.durationMinutes, this.totalDistanceMeters, this.intensityLevel = 1, this.verificationCount = 0, this.pointsEarned = 0, required this.createdAt});
  factory _PloggingSession.fromJson(Map<String, dynamic> json) => _$PloggingSessionFromJson(json);

@override final  int id;
@override final  String userId;
@override final  PloggingStatus status;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override final  int? durationMinutes;
@override final  double? totalDistanceMeters;
@override@JsonKey() final  int intensityLevel;
@override@JsonKey() final  int verificationCount;
@override@JsonKey() final  int pointsEarned;
@override final  DateTime createdAt;

/// Create a copy of PloggingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PloggingSessionCopyWith<_PloggingSession> get copyWith => __$PloggingSessionCopyWithImpl<_PloggingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PloggingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PloggingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.totalDistanceMeters, totalDistanceMeters) || other.totalDistanceMeters == totalDistanceMeters)&&(identical(other.intensityLevel, intensityLevel) || other.intensityLevel == intensityLevel)&&(identical(other.verificationCount, verificationCount) || other.verificationCount == verificationCount)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,status,startedAt,endedAt,durationMinutes,totalDistanceMeters,intensityLevel,verificationCount,pointsEarned,createdAt);

@override
String toString() {
  return 'PloggingSession(id: $id, userId: $userId, status: $status, startedAt: $startedAt, endedAt: $endedAt, durationMinutes: $durationMinutes, totalDistanceMeters: $totalDistanceMeters, intensityLevel: $intensityLevel, verificationCount: $verificationCount, pointsEarned: $pointsEarned, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PloggingSessionCopyWith<$Res> implements $PloggingSessionCopyWith<$Res> {
  factory _$PloggingSessionCopyWith(_PloggingSession value, $Res Function(_PloggingSession) _then) = __$PloggingSessionCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, PloggingStatus status, DateTime startedAt, DateTime? endedAt, int? durationMinutes, double? totalDistanceMeters, int intensityLevel, int verificationCount, int pointsEarned, DateTime createdAt
});




}
/// @nodoc
class __$PloggingSessionCopyWithImpl<$Res>
    implements _$PloggingSessionCopyWith<$Res> {
  __$PloggingSessionCopyWithImpl(this._self, this._then);

  final _PloggingSession _self;
  final $Res Function(_PloggingSession) _then;

/// Create a copy of PloggingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? durationMinutes = freezed,Object? totalDistanceMeters = freezed,Object? intensityLevel = null,Object? verificationCount = null,Object? pointsEarned = null,Object? createdAt = null,}) {
  return _then(_PloggingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PloggingStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,totalDistanceMeters: freezed == totalDistanceMeters ? _self.totalDistanceMeters : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
as double?,intensityLevel: null == intensityLevel ? _self.intensityLevel : intensityLevel // ignore: cast_nullable_to_non_nullable
as int,verificationCount: null == verificationCount ? _self.verificationCount : verificationCount // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
