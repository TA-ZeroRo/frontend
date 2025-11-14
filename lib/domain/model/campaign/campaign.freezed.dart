// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaign.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Campaign {

 int get id; String get title; String? get description; String get hostOrganizer; String get campaignUrl; String? get imageUrl; String get startDate; String? get endDate; String get region; String get category; String get status; String? get submissionType; DateTime get updatedAt;
/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignCopyWith<Campaign> get copyWith => _$CampaignCopyWithImpl<Campaign>(this as Campaign, _$identity);

  /// Serializes this Campaign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Campaign&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.hostOrganizer, hostOrganizer) || other.hostOrganizer == hostOrganizer)&&(identical(other.campaignUrl, campaignUrl) || other.campaignUrl == campaignUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.region, region) || other.region == region)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.submissionType, submissionType) || other.submissionType == submissionType)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,hostOrganizer,campaignUrl,imageUrl,startDate,endDate,region,category,status,submissionType,updatedAt);

@override
String toString() {
  return 'Campaign(id: $id, title: $title, description: $description, hostOrganizer: $hostOrganizer, campaignUrl: $campaignUrl, imageUrl: $imageUrl, startDate: $startDate, endDate: $endDate, region: $region, category: $category, status: $status, submissionType: $submissionType, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CampaignCopyWith<$Res>  {
  factory $CampaignCopyWith(Campaign value, $Res Function(Campaign) _then) = _$CampaignCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? description, String hostOrganizer, String campaignUrl, String? imageUrl, String startDate, String? endDate, String region, String category, String status, String? submissionType, DateTime updatedAt
});




}
/// @nodoc
class _$CampaignCopyWithImpl<$Res>
    implements $CampaignCopyWith<$Res> {
  _$CampaignCopyWithImpl(this._self, this._then);

  final Campaign _self;
  final $Res Function(Campaign) _then;

/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? hostOrganizer = null,Object? campaignUrl = null,Object? imageUrl = freezed,Object? startDate = null,Object? endDate = freezed,Object? region = null,Object? category = null,Object? status = null,Object? submissionType = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hostOrganizer: null == hostOrganizer ? _self.hostOrganizer : hostOrganizer // ignore: cast_nullable_to_non_nullable
as String,campaignUrl: null == campaignUrl ? _self.campaignUrl : campaignUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,submissionType: freezed == submissionType ? _self.submissionType : submissionType // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Campaign].
extension CampaignPatterns on Campaign {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Campaign value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Campaign() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Campaign value)  $default,){
final _that = this;
switch (_that) {
case _Campaign():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Campaign value)?  $default,){
final _that = this;
switch (_that) {
case _Campaign() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String hostOrganizer,  String campaignUrl,  String? imageUrl,  String startDate,  String? endDate,  String region,  String category,  String status,  String? submissionType,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Campaign() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.hostOrganizer,_that.campaignUrl,_that.imageUrl,_that.startDate,_that.endDate,_that.region,_that.category,_that.status,_that.submissionType,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String hostOrganizer,  String campaignUrl,  String? imageUrl,  String startDate,  String? endDate,  String region,  String category,  String status,  String? submissionType,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Campaign():
return $default(_that.id,_that.title,_that.description,_that.hostOrganizer,_that.campaignUrl,_that.imageUrl,_that.startDate,_that.endDate,_that.region,_that.category,_that.status,_that.submissionType,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? description,  String hostOrganizer,  String campaignUrl,  String? imageUrl,  String startDate,  String? endDate,  String region,  String category,  String status,  String? submissionType,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Campaign() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.hostOrganizer,_that.campaignUrl,_that.imageUrl,_that.startDate,_that.endDate,_that.region,_that.category,_that.status,_that.submissionType,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Campaign implements Campaign {
  const _Campaign({required this.id, required this.title, this.description, required this.hostOrganizer, required this.campaignUrl, this.imageUrl, required this.startDate, this.endDate, required this.region, required this.category, required this.status, this.submissionType, required this.updatedAt});
  factory _Campaign.fromJson(Map<String, dynamic> json) => _$CampaignFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? description;
@override final  String hostOrganizer;
@override final  String campaignUrl;
@override final  String? imageUrl;
@override final  String startDate;
@override final  String? endDate;
@override final  String region;
@override final  String category;
@override final  String status;
@override final  String? submissionType;
@override final  DateTime updatedAt;

/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampaignCopyWith<_Campaign> get copyWith => __$CampaignCopyWithImpl<_Campaign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampaignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Campaign&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.hostOrganizer, hostOrganizer) || other.hostOrganizer == hostOrganizer)&&(identical(other.campaignUrl, campaignUrl) || other.campaignUrl == campaignUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.region, region) || other.region == region)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.submissionType, submissionType) || other.submissionType == submissionType)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,hostOrganizer,campaignUrl,imageUrl,startDate,endDate,region,category,status,submissionType,updatedAt);

@override
String toString() {
  return 'Campaign(id: $id, title: $title, description: $description, hostOrganizer: $hostOrganizer, campaignUrl: $campaignUrl, imageUrl: $imageUrl, startDate: $startDate, endDate: $endDate, region: $region, category: $category, status: $status, submissionType: $submissionType, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CampaignCopyWith<$Res> implements $CampaignCopyWith<$Res> {
  factory _$CampaignCopyWith(_Campaign value, $Res Function(_Campaign) _then) = __$CampaignCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? description, String hostOrganizer, String campaignUrl, String? imageUrl, String startDate, String? endDate, String region, String category, String status, String? submissionType, DateTime updatedAt
});




}
/// @nodoc
class __$CampaignCopyWithImpl<$Res>
    implements _$CampaignCopyWith<$Res> {
  __$CampaignCopyWithImpl(this._self, this._then);

  final _Campaign _self;
  final $Res Function(_Campaign) _then;

/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? hostOrganizer = null,Object? campaignUrl = null,Object? imageUrl = freezed,Object? startDate = null,Object? endDate = freezed,Object? region = null,Object? category = null,Object? status = null,Object? submissionType = freezed,Object? updatedAt = null,}) {
  return _then(_Campaign(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hostOrganizer: null == hostOrganizer ? _self.hostOrganizer : hostOrganizer // ignore: cast_nullable_to_non_nullable
as String,campaignUrl: null == campaignUrl ? _self.campaignUrl : campaignUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,submissionType: freezed == submissionType ? _self.submissionType : submissionType // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
