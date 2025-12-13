// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaign_webview_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CampaignWebviewConfig {

 int get id; int get campaignId; String get loginUrl; String get submissionUrl; Map<String, dynamic> get loginDetection; Map<String, dynamic> get fieldSelectors; Map<String, dynamic> get fieldMapping; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of CampaignWebviewConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignWebviewConfigCopyWith<CampaignWebviewConfig> get copyWith => _$CampaignWebviewConfigCopyWithImpl<CampaignWebviewConfig>(this as CampaignWebviewConfig, _$identity);

  /// Serializes this CampaignWebviewConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignWebviewConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.loginUrl, loginUrl) || other.loginUrl == loginUrl)&&(identical(other.submissionUrl, submissionUrl) || other.submissionUrl == submissionUrl)&&const DeepCollectionEquality().equals(other.loginDetection, loginDetection)&&const DeepCollectionEquality().equals(other.fieldSelectors, fieldSelectors)&&const DeepCollectionEquality().equals(other.fieldMapping, fieldMapping)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,campaignId,loginUrl,submissionUrl,const DeepCollectionEquality().hash(loginDetection),const DeepCollectionEquality().hash(fieldSelectors),const DeepCollectionEquality().hash(fieldMapping),createdAt,updatedAt);

@override
String toString() {
  return 'CampaignWebviewConfig(id: $id, campaignId: $campaignId, loginUrl: $loginUrl, submissionUrl: $submissionUrl, loginDetection: $loginDetection, fieldSelectors: $fieldSelectors, fieldMapping: $fieldMapping, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CampaignWebviewConfigCopyWith<$Res>  {
  factory $CampaignWebviewConfigCopyWith(CampaignWebviewConfig value, $Res Function(CampaignWebviewConfig) _then) = _$CampaignWebviewConfigCopyWithImpl;
@useResult
$Res call({
 int id, int campaignId, String loginUrl, String submissionUrl, Map<String, dynamic> loginDetection, Map<String, dynamic> fieldSelectors, Map<String, dynamic> fieldMapping, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CampaignWebviewConfigCopyWithImpl<$Res>
    implements $CampaignWebviewConfigCopyWith<$Res> {
  _$CampaignWebviewConfigCopyWithImpl(this._self, this._then);

  final CampaignWebviewConfig _self;
  final $Res Function(CampaignWebviewConfig) _then;

/// Create a copy of CampaignWebviewConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? campaignId = null,Object? loginUrl = null,Object? submissionUrl = null,Object? loginDetection = null,Object? fieldSelectors = null,Object? fieldMapping = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,campaignId: null == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as int,loginUrl: null == loginUrl ? _self.loginUrl : loginUrl // ignore: cast_nullable_to_non_nullable
as String,submissionUrl: null == submissionUrl ? _self.submissionUrl : submissionUrl // ignore: cast_nullable_to_non_nullable
as String,loginDetection: null == loginDetection ? _self.loginDetection : loginDetection // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fieldSelectors: null == fieldSelectors ? _self.fieldSelectors : fieldSelectors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fieldMapping: null == fieldMapping ? _self.fieldMapping : fieldMapping // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CampaignWebviewConfig].
extension CampaignWebviewConfigPatterns on CampaignWebviewConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampaignWebviewConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampaignWebviewConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampaignWebviewConfig value)  $default,){
final _that = this;
switch (_that) {
case _CampaignWebviewConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampaignWebviewConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CampaignWebviewConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int campaignId,  String loginUrl,  String submissionUrl,  Map<String, dynamic> loginDetection,  Map<String, dynamic> fieldSelectors,  Map<String, dynamic> fieldMapping,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampaignWebviewConfig() when $default != null:
return $default(_that.id,_that.campaignId,_that.loginUrl,_that.submissionUrl,_that.loginDetection,_that.fieldSelectors,_that.fieldMapping,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int campaignId,  String loginUrl,  String submissionUrl,  Map<String, dynamic> loginDetection,  Map<String, dynamic> fieldSelectors,  Map<String, dynamic> fieldMapping,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CampaignWebviewConfig():
return $default(_that.id,_that.campaignId,_that.loginUrl,_that.submissionUrl,_that.loginDetection,_that.fieldSelectors,_that.fieldMapping,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int campaignId,  String loginUrl,  String submissionUrl,  Map<String, dynamic> loginDetection,  Map<String, dynamic> fieldSelectors,  Map<String, dynamic> fieldMapping,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CampaignWebviewConfig() when $default != null:
return $default(_that.id,_that.campaignId,_that.loginUrl,_that.submissionUrl,_that.loginDetection,_that.fieldSelectors,_that.fieldMapping,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampaignWebviewConfig implements CampaignWebviewConfig {
  const _CampaignWebviewConfig({required this.id, required this.campaignId, required this.loginUrl, required this.submissionUrl, required final  Map<String, dynamic> loginDetection, required final  Map<String, dynamic> fieldSelectors, required final  Map<String, dynamic> fieldMapping, required this.createdAt, required this.updatedAt}): _loginDetection = loginDetection,_fieldSelectors = fieldSelectors,_fieldMapping = fieldMapping;
  factory _CampaignWebviewConfig.fromJson(Map<String, dynamic> json) => _$CampaignWebviewConfigFromJson(json);

@override final  int id;
@override final  int campaignId;
@override final  String loginUrl;
@override final  String submissionUrl;
 final  Map<String, dynamic> _loginDetection;
@override Map<String, dynamic> get loginDetection {
  if (_loginDetection is EqualUnmodifiableMapView) return _loginDetection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_loginDetection);
}

 final  Map<String, dynamic> _fieldSelectors;
@override Map<String, dynamic> get fieldSelectors {
  if (_fieldSelectors is EqualUnmodifiableMapView) return _fieldSelectors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldSelectors);
}

 final  Map<String, dynamic> _fieldMapping;
@override Map<String, dynamic> get fieldMapping {
  if (_fieldMapping is EqualUnmodifiableMapView) return _fieldMapping;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldMapping);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of CampaignWebviewConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampaignWebviewConfigCopyWith<_CampaignWebviewConfig> get copyWith => __$CampaignWebviewConfigCopyWithImpl<_CampaignWebviewConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampaignWebviewConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampaignWebviewConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId)&&(identical(other.loginUrl, loginUrl) || other.loginUrl == loginUrl)&&(identical(other.submissionUrl, submissionUrl) || other.submissionUrl == submissionUrl)&&const DeepCollectionEquality().equals(other._loginDetection, _loginDetection)&&const DeepCollectionEquality().equals(other._fieldSelectors, _fieldSelectors)&&const DeepCollectionEquality().equals(other._fieldMapping, _fieldMapping)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,campaignId,loginUrl,submissionUrl,const DeepCollectionEquality().hash(_loginDetection),const DeepCollectionEquality().hash(_fieldSelectors),const DeepCollectionEquality().hash(_fieldMapping),createdAt,updatedAt);

@override
String toString() {
  return 'CampaignWebviewConfig(id: $id, campaignId: $campaignId, loginUrl: $loginUrl, submissionUrl: $submissionUrl, loginDetection: $loginDetection, fieldSelectors: $fieldSelectors, fieldMapping: $fieldMapping, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CampaignWebviewConfigCopyWith<$Res> implements $CampaignWebviewConfigCopyWith<$Res> {
  factory _$CampaignWebviewConfigCopyWith(_CampaignWebviewConfig value, $Res Function(_CampaignWebviewConfig) _then) = __$CampaignWebviewConfigCopyWithImpl;
@override @useResult
$Res call({
 int id, int campaignId, String loginUrl, String submissionUrl, Map<String, dynamic> loginDetection, Map<String, dynamic> fieldSelectors, Map<String, dynamic> fieldMapping, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CampaignWebviewConfigCopyWithImpl<$Res>
    implements _$CampaignWebviewConfigCopyWith<$Res> {
  __$CampaignWebviewConfigCopyWithImpl(this._self, this._then);

  final _CampaignWebviewConfig _self;
  final $Res Function(_CampaignWebviewConfig) _then;

/// Create a copy of CampaignWebviewConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? campaignId = null,Object? loginUrl = null,Object? submissionUrl = null,Object? loginDetection = null,Object? fieldSelectors = null,Object? fieldMapping = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CampaignWebviewConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,campaignId: null == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as int,loginUrl: null == loginUrl ? _self.loginUrl : loginUrl // ignore: cast_nullable_to_non_nullable
as String,submissionUrl: null == submissionUrl ? _self.submissionUrl : submissionUrl // ignore: cast_nullable_to_non_nullable
as String,loginDetection: null == loginDetection ? _self._loginDetection : loginDetection // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fieldSelectors: null == fieldSelectors ? _self._fieldSelectors : fieldSelectors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fieldMapping: null == fieldMapping ? _self._fieldMapping : fieldMapping // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
