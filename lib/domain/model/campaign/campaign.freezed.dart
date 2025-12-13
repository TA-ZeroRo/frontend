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

 int get id; String get title; String? get description; String get hostOrganizer; String get campaignUrl; String? get imageUrl; String? get startDate; String? get endDate; String? get region; String? get category; String get status; String? get submissionType; DateTime get updatedAt;/// 캠페인 출처 (ZERORO: 자체 캠페인, EXTERNAL: 외부 캠페인)
 CampaignSource get campaignSource;// RPA WebView 관련 필드 (레거시)
 int? get rpaSiteConfigId; String? get rpaFormUrl; Map<String, dynamic>? get rpaFormConfig; Map<String, dynamic>? get rpaFieldMapping; Map<String, dynamic>? get rpaFormSelectorStrategies; Map<String, dynamic>? get webviewConfig;
/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignCopyWith<Campaign> get copyWith => _$CampaignCopyWithImpl<Campaign>(this as Campaign, _$identity);

  /// Serializes this Campaign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Campaign&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.hostOrganizer, hostOrganizer) || other.hostOrganizer == hostOrganizer)&&(identical(other.campaignUrl, campaignUrl) || other.campaignUrl == campaignUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.region, region) || other.region == region)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.submissionType, submissionType) || other.submissionType == submissionType)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campaignSource, campaignSource) || other.campaignSource == campaignSource)&&(identical(other.rpaSiteConfigId, rpaSiteConfigId) || other.rpaSiteConfigId == rpaSiteConfigId)&&(identical(other.rpaFormUrl, rpaFormUrl) || other.rpaFormUrl == rpaFormUrl)&&const DeepCollectionEquality().equals(other.rpaFormConfig, rpaFormConfig)&&const DeepCollectionEquality().equals(other.rpaFieldMapping, rpaFieldMapping)&&const DeepCollectionEquality().equals(other.rpaFormSelectorStrategies, rpaFormSelectorStrategies)&&const DeepCollectionEquality().equals(other.webviewConfig, webviewConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,description,hostOrganizer,campaignUrl,imageUrl,startDate,endDate,region,category,status,submissionType,updatedAt,campaignSource,rpaSiteConfigId,rpaFormUrl,const DeepCollectionEquality().hash(rpaFormConfig),const DeepCollectionEquality().hash(rpaFieldMapping),const DeepCollectionEquality().hash(rpaFormSelectorStrategies),const DeepCollectionEquality().hash(webviewConfig)]);

@override
String toString() {
  return 'Campaign(id: $id, title: $title, description: $description, hostOrganizer: $hostOrganizer, campaignUrl: $campaignUrl, imageUrl: $imageUrl, startDate: $startDate, endDate: $endDate, region: $region, category: $category, status: $status, submissionType: $submissionType, updatedAt: $updatedAt, campaignSource: $campaignSource, rpaSiteConfigId: $rpaSiteConfigId, rpaFormUrl: $rpaFormUrl, rpaFormConfig: $rpaFormConfig, rpaFieldMapping: $rpaFieldMapping, rpaFormSelectorStrategies: $rpaFormSelectorStrategies, webviewConfig: $webviewConfig)';
}


}

/// @nodoc
abstract mixin class $CampaignCopyWith<$Res>  {
  factory $CampaignCopyWith(Campaign value, $Res Function(Campaign) _then) = _$CampaignCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? description, String hostOrganizer, String campaignUrl, String? imageUrl, String? startDate, String? endDate, String? region, String? category, String status, String? submissionType, DateTime updatedAt, CampaignSource campaignSource, int? rpaSiteConfigId, String? rpaFormUrl, Map<String, dynamic>? rpaFormConfig, Map<String, dynamic>? rpaFieldMapping, Map<String, dynamic>? rpaFormSelectorStrategies, Map<String, dynamic>? webviewConfig
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? hostOrganizer = null,Object? campaignUrl = null,Object? imageUrl = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? region = freezed,Object? category = freezed,Object? status = null,Object? submissionType = freezed,Object? updatedAt = null,Object? campaignSource = null,Object? rpaSiteConfigId = freezed,Object? rpaFormUrl = freezed,Object? rpaFormConfig = freezed,Object? rpaFieldMapping = freezed,Object? rpaFormSelectorStrategies = freezed,Object? webviewConfig = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hostOrganizer: null == hostOrganizer ? _self.hostOrganizer : hostOrganizer // ignore: cast_nullable_to_non_nullable
as String,campaignUrl: null == campaignUrl ? _self.campaignUrl : campaignUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,submissionType: freezed == submissionType ? _self.submissionType : submissionType // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,campaignSource: null == campaignSource ? _self.campaignSource : campaignSource // ignore: cast_nullable_to_non_nullable
as CampaignSource,rpaSiteConfigId: freezed == rpaSiteConfigId ? _self.rpaSiteConfigId : rpaSiteConfigId // ignore: cast_nullable_to_non_nullable
as int?,rpaFormUrl: freezed == rpaFormUrl ? _self.rpaFormUrl : rpaFormUrl // ignore: cast_nullable_to_non_nullable
as String?,rpaFormConfig: freezed == rpaFormConfig ? _self.rpaFormConfig : rpaFormConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rpaFieldMapping: freezed == rpaFieldMapping ? _self.rpaFieldMapping : rpaFieldMapping // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rpaFormSelectorStrategies: freezed == rpaFormSelectorStrategies ? _self.rpaFormSelectorStrategies : rpaFormSelectorStrategies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,webviewConfig: freezed == webviewConfig ? _self.webviewConfig : webviewConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String hostOrganizer,  String campaignUrl,  String? imageUrl,  String? startDate,  String? endDate,  String? region,  String? category,  String status,  String? submissionType,  DateTime updatedAt,  CampaignSource campaignSource,  int? rpaSiteConfigId,  String? rpaFormUrl,  Map<String, dynamic>? rpaFormConfig,  Map<String, dynamic>? rpaFieldMapping,  Map<String, dynamic>? rpaFormSelectorStrategies,  Map<String, dynamic>? webviewConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Campaign() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.hostOrganizer,_that.campaignUrl,_that.imageUrl,_that.startDate,_that.endDate,_that.region,_that.category,_that.status,_that.submissionType,_that.updatedAt,_that.campaignSource,_that.rpaSiteConfigId,_that.rpaFormUrl,_that.rpaFormConfig,_that.rpaFieldMapping,_that.rpaFormSelectorStrategies,_that.webviewConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String hostOrganizer,  String campaignUrl,  String? imageUrl,  String? startDate,  String? endDate,  String? region,  String? category,  String status,  String? submissionType,  DateTime updatedAt,  CampaignSource campaignSource,  int? rpaSiteConfigId,  String? rpaFormUrl,  Map<String, dynamic>? rpaFormConfig,  Map<String, dynamic>? rpaFieldMapping,  Map<String, dynamic>? rpaFormSelectorStrategies,  Map<String, dynamic>? webviewConfig)  $default,) {final _that = this;
switch (_that) {
case _Campaign():
return $default(_that.id,_that.title,_that.description,_that.hostOrganizer,_that.campaignUrl,_that.imageUrl,_that.startDate,_that.endDate,_that.region,_that.category,_that.status,_that.submissionType,_that.updatedAt,_that.campaignSource,_that.rpaSiteConfigId,_that.rpaFormUrl,_that.rpaFormConfig,_that.rpaFieldMapping,_that.rpaFormSelectorStrategies,_that.webviewConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? description,  String hostOrganizer,  String campaignUrl,  String? imageUrl,  String? startDate,  String? endDate,  String? region,  String? category,  String status,  String? submissionType,  DateTime updatedAt,  CampaignSource campaignSource,  int? rpaSiteConfigId,  String? rpaFormUrl,  Map<String, dynamic>? rpaFormConfig,  Map<String, dynamic>? rpaFieldMapping,  Map<String, dynamic>? rpaFormSelectorStrategies,  Map<String, dynamic>? webviewConfig)?  $default,) {final _that = this;
switch (_that) {
case _Campaign() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.hostOrganizer,_that.campaignUrl,_that.imageUrl,_that.startDate,_that.endDate,_that.region,_that.category,_that.status,_that.submissionType,_that.updatedAt,_that.campaignSource,_that.rpaSiteConfigId,_that.rpaFormUrl,_that.rpaFormConfig,_that.rpaFieldMapping,_that.rpaFormSelectorStrategies,_that.webviewConfig);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Campaign implements Campaign {
  const _Campaign({required this.id, required this.title, this.description, required this.hostOrganizer, required this.campaignUrl, this.imageUrl, this.startDate, this.endDate, this.region, this.category, required this.status, this.submissionType, required this.updatedAt, this.campaignSource = CampaignSource.external, this.rpaSiteConfigId, this.rpaFormUrl, final  Map<String, dynamic>? rpaFormConfig, final  Map<String, dynamic>? rpaFieldMapping, final  Map<String, dynamic>? rpaFormSelectorStrategies, final  Map<String, dynamic>? webviewConfig}): _rpaFormConfig = rpaFormConfig,_rpaFieldMapping = rpaFieldMapping,_rpaFormSelectorStrategies = rpaFormSelectorStrategies,_webviewConfig = webviewConfig;
  factory _Campaign.fromJson(Map<String, dynamic> json) => _$CampaignFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? description;
@override final  String hostOrganizer;
@override final  String campaignUrl;
@override final  String? imageUrl;
@override final  String? startDate;
@override final  String? endDate;
@override final  String? region;
@override final  String? category;
@override final  String status;
@override final  String? submissionType;
@override final  DateTime updatedAt;
/// 캠페인 출처 (ZERORO: 자체 캠페인, EXTERNAL: 외부 캠페인)
@override@JsonKey() final  CampaignSource campaignSource;
// RPA WebView 관련 필드 (레거시)
@override final  int? rpaSiteConfigId;
@override final  String? rpaFormUrl;
 final  Map<String, dynamic>? _rpaFormConfig;
@override Map<String, dynamic>? get rpaFormConfig {
  final value = _rpaFormConfig;
  if (value == null) return null;
  if (_rpaFormConfig is EqualUnmodifiableMapView) return _rpaFormConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _rpaFieldMapping;
@override Map<String, dynamic>? get rpaFieldMapping {
  final value = _rpaFieldMapping;
  if (value == null) return null;
  if (_rpaFieldMapping is EqualUnmodifiableMapView) return _rpaFieldMapping;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _rpaFormSelectorStrategies;
@override Map<String, dynamic>? get rpaFormSelectorStrategies {
  final value = _rpaFormSelectorStrategies;
  if (value == null) return null;
  if (_rpaFormSelectorStrategies is EqualUnmodifiableMapView) return _rpaFormSelectorStrategies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _webviewConfig;
@override Map<String, dynamic>? get webviewConfig {
  final value = _webviewConfig;
  if (value == null) return null;
  if (_webviewConfig is EqualUnmodifiableMapView) return _webviewConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Campaign&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.hostOrganizer, hostOrganizer) || other.hostOrganizer == hostOrganizer)&&(identical(other.campaignUrl, campaignUrl) || other.campaignUrl == campaignUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.region, region) || other.region == region)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.submissionType, submissionType) || other.submissionType == submissionType)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campaignSource, campaignSource) || other.campaignSource == campaignSource)&&(identical(other.rpaSiteConfigId, rpaSiteConfigId) || other.rpaSiteConfigId == rpaSiteConfigId)&&(identical(other.rpaFormUrl, rpaFormUrl) || other.rpaFormUrl == rpaFormUrl)&&const DeepCollectionEquality().equals(other._rpaFormConfig, _rpaFormConfig)&&const DeepCollectionEquality().equals(other._rpaFieldMapping, _rpaFieldMapping)&&const DeepCollectionEquality().equals(other._rpaFormSelectorStrategies, _rpaFormSelectorStrategies)&&const DeepCollectionEquality().equals(other._webviewConfig, _webviewConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,description,hostOrganizer,campaignUrl,imageUrl,startDate,endDate,region,category,status,submissionType,updatedAt,campaignSource,rpaSiteConfigId,rpaFormUrl,const DeepCollectionEquality().hash(_rpaFormConfig),const DeepCollectionEquality().hash(_rpaFieldMapping),const DeepCollectionEquality().hash(_rpaFormSelectorStrategies),const DeepCollectionEquality().hash(_webviewConfig)]);

@override
String toString() {
  return 'Campaign(id: $id, title: $title, description: $description, hostOrganizer: $hostOrganizer, campaignUrl: $campaignUrl, imageUrl: $imageUrl, startDate: $startDate, endDate: $endDate, region: $region, category: $category, status: $status, submissionType: $submissionType, updatedAt: $updatedAt, campaignSource: $campaignSource, rpaSiteConfigId: $rpaSiteConfigId, rpaFormUrl: $rpaFormUrl, rpaFormConfig: $rpaFormConfig, rpaFieldMapping: $rpaFieldMapping, rpaFormSelectorStrategies: $rpaFormSelectorStrategies, webviewConfig: $webviewConfig)';
}


}

/// @nodoc
abstract mixin class _$CampaignCopyWith<$Res> implements $CampaignCopyWith<$Res> {
  factory _$CampaignCopyWith(_Campaign value, $Res Function(_Campaign) _then) = __$CampaignCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? description, String hostOrganizer, String campaignUrl, String? imageUrl, String? startDate, String? endDate, String? region, String? category, String status, String? submissionType, DateTime updatedAt, CampaignSource campaignSource, int? rpaSiteConfigId, String? rpaFormUrl, Map<String, dynamic>? rpaFormConfig, Map<String, dynamic>? rpaFieldMapping, Map<String, dynamic>? rpaFormSelectorStrategies, Map<String, dynamic>? webviewConfig
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? hostOrganizer = null,Object? campaignUrl = null,Object? imageUrl = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? region = freezed,Object? category = freezed,Object? status = null,Object? submissionType = freezed,Object? updatedAt = null,Object? campaignSource = null,Object? rpaSiteConfigId = freezed,Object? rpaFormUrl = freezed,Object? rpaFormConfig = freezed,Object? rpaFieldMapping = freezed,Object? rpaFormSelectorStrategies = freezed,Object? webviewConfig = freezed,}) {
  return _then(_Campaign(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hostOrganizer: null == hostOrganizer ? _self.hostOrganizer : hostOrganizer // ignore: cast_nullable_to_non_nullable
as String,campaignUrl: null == campaignUrl ? _self.campaignUrl : campaignUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,submissionType: freezed == submissionType ? _self.submissionType : submissionType // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,campaignSource: null == campaignSource ? _self.campaignSource : campaignSource // ignore: cast_nullable_to_non_nullable
as CampaignSource,rpaSiteConfigId: freezed == rpaSiteConfigId ? _self.rpaSiteConfigId : rpaSiteConfigId // ignore: cast_nullable_to_non_nullable
as int?,rpaFormUrl: freezed == rpaFormUrl ? _self.rpaFormUrl : rpaFormUrl // ignore: cast_nullable_to_non_nullable
as String?,rpaFormConfig: freezed == rpaFormConfig ? _self._rpaFormConfig : rpaFormConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rpaFieldMapping: freezed == rpaFieldMapping ? _self._rpaFieldMapping : rpaFieldMapping // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rpaFormSelectorStrategies: freezed == rpaFormSelectorStrategies ? _self._rpaFormSelectorStrategies : rpaFormSelectorStrategies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,webviewConfig: freezed == webviewConfig ? _self._webviewConfig : webviewConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
