// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MissionTemplate {

 int get id; int get campaignId; String get title; String get description; VerificationType get verificationType; int get rewardPoints; int get order; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionTemplateCopyWith<MissionTemplate> get copyWith => _$MissionTemplateCopyWithImpl<MissionTemplate>(this as MissionTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.verificationType, verificationType) || other.verificationType == verificationType)&&(identical(other.rewardPoints, rewardPoints) || other.rewardPoints == rewardPoints)&&(identical(other.order, order) || other.order == order)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,campaignId,title,description,verificationType,rewardPoints,order,createdAt,updatedAt);

@override
String toString() {
  return 'MissionTemplate(id: $id, campaignId: $campaignId, title: $title, description: $description, verificationType: $verificationType, rewardPoints: $rewardPoints, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MissionTemplateCopyWith<$Res>  {
  factory $MissionTemplateCopyWith(MissionTemplate value, $Res Function(MissionTemplate) _then) = _$MissionTemplateCopyWithImpl;
@useResult
$Res call({
 int id, int campaignId, String title, String description, VerificationType verificationType, int rewardPoints, int order, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MissionTemplateCopyWithImpl<$Res>
    implements $MissionTemplateCopyWith<$Res> {
  _$MissionTemplateCopyWithImpl(this._self, this._then);

  final MissionTemplate _self;
  final $Res Function(MissionTemplate) _then;

/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? campaignId = null,Object? title = null,Object? description = null,Object? verificationType = null,Object? rewardPoints = null,Object? order = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,campaignId: null == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verificationType: null == verificationType ? _self.verificationType : verificationType // ignore: cast_nullable_to_non_nullable
as VerificationType,rewardPoints: null == rewardPoints ? _self.rewardPoints : rewardPoints // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionTemplate].
extension MissionTemplatePatterns on MissionTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionTemplate value)  $default,){
final _that = this;
switch (_that) {
case _MissionTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _MissionTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int campaignId,  String title,  String description,  VerificationType verificationType,  int rewardPoints,  int order,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionTemplate() when $default != null:
return $default(_that.id,_that.campaignId,_that.title,_that.description,_that.verificationType,_that.rewardPoints,_that.order,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int campaignId,  String title,  String description,  VerificationType verificationType,  int rewardPoints,  int order,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MissionTemplate():
return $default(_that.id,_that.campaignId,_that.title,_that.description,_that.verificationType,_that.rewardPoints,_that.order,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int campaignId,  String title,  String description,  VerificationType verificationType,  int rewardPoints,  int order,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MissionTemplate() when $default != null:
return $default(_that.id,_that.campaignId,_that.title,_that.description,_that.verificationType,_that.rewardPoints,_that.order,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MissionTemplate implements MissionTemplate {
  const _MissionTemplate({required this.id, required this.campaignId, required this.title, required this.description, required this.verificationType, required this.rewardPoints, required this.order, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int campaignId;
@override final  String title;
@override final  String description;
@override final  VerificationType verificationType;
@override final  int rewardPoints;
@override final  int order;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionTemplateCopyWith<_MissionTemplate> get copyWith => __$MissionTemplateCopyWithImpl<_MissionTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.verificationType, verificationType) || other.verificationType == verificationType)&&(identical(other.rewardPoints, rewardPoints) || other.rewardPoints == rewardPoints)&&(identical(other.order, order) || other.order == order)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,campaignId,title,description,verificationType,rewardPoints,order,createdAt,updatedAt);

@override
String toString() {
  return 'MissionTemplate(id: $id, campaignId: $campaignId, title: $title, description: $description, verificationType: $verificationType, rewardPoints: $rewardPoints, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MissionTemplateCopyWith<$Res> implements $MissionTemplateCopyWith<$Res> {
  factory _$MissionTemplateCopyWith(_MissionTemplate value, $Res Function(_MissionTemplate) _then) = __$MissionTemplateCopyWithImpl;
@override @useResult
$Res call({
 int id, int campaignId, String title, String description, VerificationType verificationType, int rewardPoints, int order, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MissionTemplateCopyWithImpl<$Res>
    implements _$MissionTemplateCopyWith<$Res> {
  __$MissionTemplateCopyWithImpl(this._self, this._then);

  final _MissionTemplate _self;
  final $Res Function(_MissionTemplate) _then;

/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? campaignId = null,Object? title = null,Object? description = null,Object? verificationType = null,Object? rewardPoints = null,Object? order = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MissionTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,campaignId: null == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verificationType: null == verificationType ? _self.verificationType : verificationType // ignore: cast_nullable_to_non_nullable
as VerificationType,rewardPoints: null == rewardPoints ? _self.rewardPoints : rewardPoints // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
