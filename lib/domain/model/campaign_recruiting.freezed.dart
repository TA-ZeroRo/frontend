// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaign_recruiting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CampaignRecruiting {

 int get id; String get userId; String get username; String? get userImg; String get title; int get recruitmentCount; String get campaignName; String get requirements; String? get url; String get createdAt;
/// Create a copy of CampaignRecruiting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignRecruitingCopyWith<CampaignRecruiting> get copyWith => _$CampaignRecruitingCopyWithImpl<CampaignRecruiting>(this as CampaignRecruiting, _$identity);

  /// Serializes this CampaignRecruiting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignRecruiting&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userImg, userImg) || other.userImg == userImg)&&(identical(other.title, title) || other.title == title)&&(identical(other.recruitmentCount, recruitmentCount) || other.recruitmentCount == recruitmentCount)&&(identical(other.campaignName, campaignName) || other.campaignName == campaignName)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.url, url) || other.url == url)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,userImg,title,recruitmentCount,campaignName,requirements,url,createdAt);

@override
String toString() {
  return 'CampaignRecruiting(id: $id, userId: $userId, username: $username, userImg: $userImg, title: $title, recruitmentCount: $recruitmentCount, campaignName: $campaignName, requirements: $requirements, url: $url, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CampaignRecruitingCopyWith<$Res>  {
  factory $CampaignRecruitingCopyWith(CampaignRecruiting value, $Res Function(CampaignRecruiting) _then) = _$CampaignRecruitingCopyWithImpl;
@useResult
$Res call({
 int id, String userId, String username, String? userImg, String title, int recruitmentCount, String campaignName, String requirements, String? url, String createdAt
});




}
/// @nodoc
class _$CampaignRecruitingCopyWithImpl<$Res>
    implements $CampaignRecruitingCopyWith<$Res> {
  _$CampaignRecruitingCopyWithImpl(this._self, this._then);

  final CampaignRecruiting _self;
  final $Res Function(CampaignRecruiting) _then;

/// Create a copy of CampaignRecruiting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? username = null,Object? userImg = freezed,Object? title = null,Object? recruitmentCount = null,Object? campaignName = null,Object? requirements = null,Object? url = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userImg: freezed == userImg ? _self.userImg : userImg // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,recruitmentCount: null == recruitmentCount ? _self.recruitmentCount : recruitmentCount // ignore: cast_nullable_to_non_nullable
as int,campaignName: null == campaignName ? _self.campaignName : campaignName // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CampaignRecruiting].
extension CampaignRecruitingPatterns on CampaignRecruiting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampaignRecruiting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampaignRecruiting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampaignRecruiting value)  $default,){
final _that = this;
switch (_that) {
case _CampaignRecruiting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampaignRecruiting value)?  $default,){
final _that = this;
switch (_that) {
case _CampaignRecruiting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  String username,  String? userImg,  String title,  int recruitmentCount,  String campaignName,  String requirements,  String? url,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampaignRecruiting() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.userImg,_that.title,_that.recruitmentCount,_that.campaignName,_that.requirements,_that.url,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  String username,  String? userImg,  String title,  int recruitmentCount,  String campaignName,  String requirements,  String? url,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _CampaignRecruiting():
return $default(_that.id,_that.userId,_that.username,_that.userImg,_that.title,_that.recruitmentCount,_that.campaignName,_that.requirements,_that.url,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  String username,  String? userImg,  String title,  int recruitmentCount,  String campaignName,  String requirements,  String? url,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CampaignRecruiting() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.userImg,_that.title,_that.recruitmentCount,_that.campaignName,_that.requirements,_that.url,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampaignRecruiting implements CampaignRecruiting {
  const _CampaignRecruiting({required this.id, required this.userId, required this.username, this.userImg, required this.title, required this.recruitmentCount, required this.campaignName, required this.requirements, this.url, required this.createdAt});
  factory _CampaignRecruiting.fromJson(Map<String, dynamic> json) => _$CampaignRecruitingFromJson(json);

@override final  int id;
@override final  String userId;
@override final  String username;
@override final  String? userImg;
@override final  String title;
@override final  int recruitmentCount;
@override final  String campaignName;
@override final  String requirements;
@override final  String? url;
@override final  String createdAt;

/// Create a copy of CampaignRecruiting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampaignRecruitingCopyWith<_CampaignRecruiting> get copyWith => __$CampaignRecruitingCopyWithImpl<_CampaignRecruiting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampaignRecruitingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampaignRecruiting&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userImg, userImg) || other.userImg == userImg)&&(identical(other.title, title) || other.title == title)&&(identical(other.recruitmentCount, recruitmentCount) || other.recruitmentCount == recruitmentCount)&&(identical(other.campaignName, campaignName) || other.campaignName == campaignName)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.url, url) || other.url == url)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,userImg,title,recruitmentCount,campaignName,requirements,url,createdAt);

@override
String toString() {
  return 'CampaignRecruiting(id: $id, userId: $userId, username: $username, userImg: $userImg, title: $title, recruitmentCount: $recruitmentCount, campaignName: $campaignName, requirements: $requirements, url: $url, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CampaignRecruitingCopyWith<$Res> implements $CampaignRecruitingCopyWith<$Res> {
  factory _$CampaignRecruitingCopyWith(_CampaignRecruiting value, $Res Function(_CampaignRecruiting) _then) = __$CampaignRecruitingCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, String username, String? userImg, String title, int recruitmentCount, String campaignName, String requirements, String? url, String createdAt
});




}
/// @nodoc
class __$CampaignRecruitingCopyWithImpl<$Res>
    implements _$CampaignRecruitingCopyWith<$Res> {
  __$CampaignRecruitingCopyWithImpl(this._self, this._then);

  final _CampaignRecruiting _self;
  final $Res Function(_CampaignRecruiting) _then;

/// Create a copy of CampaignRecruiting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? username = null,Object? userImg = freezed,Object? title = null,Object? recruitmentCount = null,Object? campaignName = null,Object? requirements = null,Object? url = freezed,Object? createdAt = null,}) {
  return _then(_CampaignRecruiting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userImg: freezed == userImg ? _self.userImg : userImg // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,recruitmentCount: null == recruitmentCount ? _self.recruitmentCount : recruitmentCount // ignore: cast_nullable_to_non_nullable
as int,campaignName: null == campaignName ? _self.campaignName : campaignName // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
