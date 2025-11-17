// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_with_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MissionWithTemplate {

 MissionLog get missionLog; MissionTemplate get missionTemplate; Campaign get campaign;
/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionWithTemplateCopyWith<MissionWithTemplate> get copyWith => _$MissionWithTemplateCopyWithImpl<MissionWithTemplate>(this as MissionWithTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionWithTemplate&&(identical(other.missionLog, missionLog) || other.missionLog == missionLog)&&(identical(other.missionTemplate, missionTemplate) || other.missionTemplate == missionTemplate)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,missionLog,missionTemplate,campaign);

@override
String toString() {
  return 'MissionWithTemplate(missionLog: $missionLog, missionTemplate: $missionTemplate, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $MissionWithTemplateCopyWith<$Res>  {
  factory $MissionWithTemplateCopyWith(MissionWithTemplate value, $Res Function(MissionWithTemplate) _then) = _$MissionWithTemplateCopyWithImpl;
@useResult
$Res call({
 MissionLog missionLog, MissionTemplate missionTemplate, Campaign campaign
});


$MissionLogCopyWith<$Res> get missionLog;$MissionTemplateCopyWith<$Res> get missionTemplate;$CampaignCopyWith<$Res> get campaign;

}
/// @nodoc
class _$MissionWithTemplateCopyWithImpl<$Res>
    implements $MissionWithTemplateCopyWith<$Res> {
  _$MissionWithTemplateCopyWithImpl(this._self, this._then);

  final MissionWithTemplate _self;
  final $Res Function(MissionWithTemplate) _then;

/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? missionLog = null,Object? missionTemplate = null,Object? campaign = null,}) {
  return _then(_self.copyWith(
missionLog: null == missionLog ? _self.missionLog : missionLog // ignore: cast_nullable_to_non_nullable
as MissionLog,missionTemplate: null == missionTemplate ? _self.missionTemplate : missionTemplate // ignore: cast_nullable_to_non_nullable
as MissionTemplate,campaign: null == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as Campaign,
  ));
}
/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionLogCopyWith<$Res> get missionLog {
  
  return $MissionLogCopyWith<$Res>(_self.missionLog, (value) {
    return _then(_self.copyWith(missionLog: value));
  });
}/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionTemplateCopyWith<$Res> get missionTemplate {
  
  return $MissionTemplateCopyWith<$Res>(_self.missionTemplate, (value) {
    return _then(_self.copyWith(missionTemplate: value));
  });
}/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampaignCopyWith<$Res> get campaign {
  
  return $CampaignCopyWith<$Res>(_self.campaign, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}


/// Adds pattern-matching-related methods to [MissionWithTemplate].
extension MissionWithTemplatePatterns on MissionWithTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionWithTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionWithTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionWithTemplate value)  $default,){
final _that = this;
switch (_that) {
case _MissionWithTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionWithTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _MissionWithTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MissionLog missionLog,  MissionTemplate missionTemplate,  Campaign campaign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionWithTemplate() when $default != null:
return $default(_that.missionLog,_that.missionTemplate,_that.campaign);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MissionLog missionLog,  MissionTemplate missionTemplate,  Campaign campaign)  $default,) {final _that = this;
switch (_that) {
case _MissionWithTemplate():
return $default(_that.missionLog,_that.missionTemplate,_that.campaign);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MissionLog missionLog,  MissionTemplate missionTemplate,  Campaign campaign)?  $default,) {final _that = this;
switch (_that) {
case _MissionWithTemplate() when $default != null:
return $default(_that.missionLog,_that.missionTemplate,_that.campaign);case _:
  return null;

}
}

}

/// @nodoc


class _MissionWithTemplate implements MissionWithTemplate {
  const _MissionWithTemplate({required this.missionLog, required this.missionTemplate, required this.campaign});
  

@override final  MissionLog missionLog;
@override final  MissionTemplate missionTemplate;
@override final  Campaign campaign;

/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionWithTemplateCopyWith<_MissionWithTemplate> get copyWith => __$MissionWithTemplateCopyWithImpl<_MissionWithTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionWithTemplate&&(identical(other.missionLog, missionLog) || other.missionLog == missionLog)&&(identical(other.missionTemplate, missionTemplate) || other.missionTemplate == missionTemplate)&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,missionLog,missionTemplate,campaign);

@override
String toString() {
  return 'MissionWithTemplate(missionLog: $missionLog, missionTemplate: $missionTemplate, campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class _$MissionWithTemplateCopyWith<$Res> implements $MissionWithTemplateCopyWith<$Res> {
  factory _$MissionWithTemplateCopyWith(_MissionWithTemplate value, $Res Function(_MissionWithTemplate) _then) = __$MissionWithTemplateCopyWithImpl;
@override @useResult
$Res call({
 MissionLog missionLog, MissionTemplate missionTemplate, Campaign campaign
});


@override $MissionLogCopyWith<$Res> get missionLog;@override $MissionTemplateCopyWith<$Res> get missionTemplate;@override $CampaignCopyWith<$Res> get campaign;

}
/// @nodoc
class __$MissionWithTemplateCopyWithImpl<$Res>
    implements _$MissionWithTemplateCopyWith<$Res> {
  __$MissionWithTemplateCopyWithImpl(this._self, this._then);

  final _MissionWithTemplate _self;
  final $Res Function(_MissionWithTemplate) _then;

/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? missionLog = null,Object? missionTemplate = null,Object? campaign = null,}) {
  return _then(_MissionWithTemplate(
missionLog: null == missionLog ? _self.missionLog : missionLog // ignore: cast_nullable_to_non_nullable
as MissionLog,missionTemplate: null == missionTemplate ? _self.missionTemplate : missionTemplate // ignore: cast_nullable_to_non_nullable
as MissionTemplate,campaign: null == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as Campaign,
  ));
}

/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionLogCopyWith<$Res> get missionLog {
  
  return $MissionLogCopyWith<$Res>(_self.missionLog, (value) {
    return _then(_self.copyWith(missionLog: value));
  });
}/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionTemplateCopyWith<$Res> get missionTemplate {
  
  return $MissionTemplateCopyWith<$Res>(_self.missionTemplate, (value) {
    return _then(_self.copyWith(missionTemplate: value));
  });
}/// Create a copy of MissionWithTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampaignCopyWith<$Res> get campaign {
  
  return $CampaignCopyWith<$Res>(_self.campaign, (value) {
    return _then(_self.copyWith(campaign: value));
  });
}
}

// dart format on
