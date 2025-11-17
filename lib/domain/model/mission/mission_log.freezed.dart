// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MissionLog {

 int get id; String get userId; int get missionTemplateId; MissionStatus get status; DateTime get startedAt; DateTime? get completedAt; Map<String, dynamic>? get proofData; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MissionLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionLogCopyWith<MissionLog> get copyWith => _$MissionLogCopyWithImpl<MissionLog>(this as MissionLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.missionTemplateId, missionTemplateId) || other.missionTemplateId == missionTemplateId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other.proofData, proofData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,missionTemplateId,status,startedAt,completedAt,const DeepCollectionEquality().hash(proofData),createdAt,updatedAt);

@override
String toString() {
  return 'MissionLog(id: $id, userId: $userId, missionTemplateId: $missionTemplateId, status: $status, startedAt: $startedAt, completedAt: $completedAt, proofData: $proofData, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MissionLogCopyWith<$Res>  {
  factory $MissionLogCopyWith(MissionLog value, $Res Function(MissionLog) _then) = _$MissionLogCopyWithImpl;
@useResult
$Res call({
 int id, String userId, int missionTemplateId, MissionStatus status, DateTime startedAt, DateTime? completedAt, Map<String, dynamic>? proofData, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MissionLogCopyWithImpl<$Res>
    implements $MissionLogCopyWith<$Res> {
  _$MissionLogCopyWithImpl(this._self, this._then);

  final MissionLog _self;
  final $Res Function(MissionLog) _then;

/// Create a copy of MissionLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? missionTemplateId = null,Object? status = null,Object? startedAt = null,Object? completedAt = freezed,Object? proofData = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,missionTemplateId: null == missionTemplateId ? _self.missionTemplateId : missionTemplateId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MissionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proofData: freezed == proofData ? _self.proofData : proofData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionLog].
extension MissionLogPatterns on MissionLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionLog value)  $default,){
final _that = this;
switch (_that) {
case _MissionLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionLog value)?  $default,){
final _that = this;
switch (_that) {
case _MissionLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  int missionTemplateId,  MissionStatus status,  DateTime startedAt,  DateTime? completedAt,  Map<String, dynamic>? proofData,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionLog() when $default != null:
return $default(_that.id,_that.userId,_that.missionTemplateId,_that.status,_that.startedAt,_that.completedAt,_that.proofData,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  int missionTemplateId,  MissionStatus status,  DateTime startedAt,  DateTime? completedAt,  Map<String, dynamic>? proofData,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MissionLog():
return $default(_that.id,_that.userId,_that.missionTemplateId,_that.status,_that.startedAt,_that.completedAt,_that.proofData,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  int missionTemplateId,  MissionStatus status,  DateTime startedAt,  DateTime? completedAt,  Map<String, dynamic>? proofData,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MissionLog() when $default != null:
return $default(_that.id,_that.userId,_that.missionTemplateId,_that.status,_that.startedAt,_that.completedAt,_that.proofData,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MissionLog implements MissionLog {
  const _MissionLog({required this.id, required this.userId, required this.missionTemplateId, required this.status, required this.startedAt, this.completedAt, final  Map<String, dynamic>? proofData, required this.createdAt, required this.updatedAt}): _proofData = proofData;
  

@override final  int id;
@override final  String userId;
@override final  int missionTemplateId;
@override final  MissionStatus status;
@override final  DateTime startedAt;
@override final  DateTime? completedAt;
 final  Map<String, dynamic>? _proofData;
@override Map<String, dynamic>? get proofData {
  final value = _proofData;
  if (value == null) return null;
  if (_proofData is EqualUnmodifiableMapView) return _proofData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MissionLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionLogCopyWith<_MissionLog> get copyWith => __$MissionLogCopyWithImpl<_MissionLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.missionTemplateId, missionTemplateId) || other.missionTemplateId == missionTemplateId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other._proofData, _proofData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,missionTemplateId,status,startedAt,completedAt,const DeepCollectionEquality().hash(_proofData),createdAt,updatedAt);

@override
String toString() {
  return 'MissionLog(id: $id, userId: $userId, missionTemplateId: $missionTemplateId, status: $status, startedAt: $startedAt, completedAt: $completedAt, proofData: $proofData, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MissionLogCopyWith<$Res> implements $MissionLogCopyWith<$Res> {
  factory _$MissionLogCopyWith(_MissionLog value, $Res Function(_MissionLog) _then) = __$MissionLogCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, int missionTemplateId, MissionStatus status, DateTime startedAt, DateTime? completedAt, Map<String, dynamic>? proofData, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MissionLogCopyWithImpl<$Res>
    implements _$MissionLogCopyWith<$Res> {
  __$MissionLogCopyWithImpl(this._self, this._then);

  final _MissionLog _self;
  final $Res Function(_MissionLog) _then;

/// Create a copy of MissionLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? missionTemplateId = null,Object? status = null,Object? startedAt = null,Object? completedAt = freezed,Object? proofData = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MissionLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,missionTemplateId: null == missionTemplateId ? _self.missionTemplateId : missionTemplateId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MissionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,proofData: freezed == proofData ? _self._proofData : proofData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
