// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get userId; String get username; String? get userImg; int get totalPoints; int get continuousDays; DateTime? get birthDate;// 생년월일
 String? get region;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userImg, userImg) || other.userImg == userImg)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.continuousDays, continuousDays) || other.continuousDays == continuousDays)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.region, region) || other.region == region));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,userImg,totalPoints,continuousDays,birthDate,region);

@override
String toString() {
  return 'Profile(userId: $userId, username: $username, userImg: $userImg, totalPoints: $totalPoints, continuousDays: $continuousDays, birthDate: $birthDate, region: $region)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String userId, String username, String? userImg, int totalPoints, int continuousDays, DateTime? birthDate, String? region
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? userImg = freezed,Object? totalPoints = null,Object? continuousDays = null,Object? birthDate = freezed,Object? region = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userImg: freezed == userImg ? _self.userImg : userImg // ignore: cast_nullable_to_non_nullable
as String?,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,continuousDays: null == continuousDays ? _self.continuousDays : continuousDays // ignore: cast_nullable_to_non_nullable
as int,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String username,  String? userImg,  int totalPoints,  int continuousDays,  DateTime? birthDate,  String? region)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.userId,_that.username,_that.userImg,_that.totalPoints,_that.continuousDays,_that.birthDate,_that.region);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String username,  String? userImg,  int totalPoints,  int continuousDays,  DateTime? birthDate,  String? region)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.userId,_that.username,_that.userImg,_that.totalPoints,_that.continuousDays,_that.birthDate,_that.region);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String username,  String? userImg,  int totalPoints,  int continuousDays,  DateTime? birthDate,  String? region)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.userId,_that.username,_that.userImg,_that.totalPoints,_that.continuousDays,_that.birthDate,_that.region);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.userId, required this.username, this.userImg, this.totalPoints = 0, this.continuousDays = 0, this.birthDate, this.region});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String userId;
@override final  String username;
@override final  String? userImg;
@override@JsonKey() final  int totalPoints;
@override@JsonKey() final  int continuousDays;
@override final  DateTime? birthDate;
// 생년월일
@override final  String? region;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userImg, userImg) || other.userImg == userImg)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.continuousDays, continuousDays) || other.continuousDays == continuousDays)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.region, region) || other.region == region));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,userImg,totalPoints,continuousDays,birthDate,region);

@override
String toString() {
  return 'Profile(userId: $userId, username: $username, userImg: $userImg, totalPoints: $totalPoints, continuousDays: $continuousDays, birthDate: $birthDate, region: $region)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String userId, String username, String? userImg, int totalPoints, int continuousDays, DateTime? birthDate, String? region
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? userImg = freezed,Object? totalPoints = null,Object? continuousDays = null,Object? birthDate = freezed,Object? region = freezed,}) {
  return _then(_Profile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userImg: freezed == userImg ? _self.userImg : userImg // ignore: cast_nullable_to_non_nullable
as String?,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,continuousDays: null == continuousDays ? _self.continuousDays : continuousDays // ignore: cast_nullable_to_non_nullable
as int,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
