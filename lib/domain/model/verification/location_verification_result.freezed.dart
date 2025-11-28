// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_verification_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationVerificationResult {

/// 검증 성공 여부
 bool get isValid;/// 검증 결과 메시지
 String get reason;/// 캠페인 장소와의 거리 (미터 단위)
 double? get distance;/// 검증 시간
 DateTime? get verifiedAt;/// 캠페인 장소 주소
 String? get locationAddress;
/// Create a copy of LocationVerificationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationVerificationResultCopyWith<LocationVerificationResult> get copyWith => _$LocationVerificationResultCopyWithImpl<LocationVerificationResult>(this as LocationVerificationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationVerificationResult&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.locationAddress, locationAddress) || other.locationAddress == locationAddress));
}


@override
int get hashCode => Object.hash(runtimeType,isValid,reason,distance,verifiedAt,locationAddress);

@override
String toString() {
  return 'LocationVerificationResult(isValid: $isValid, reason: $reason, distance: $distance, verifiedAt: $verifiedAt, locationAddress: $locationAddress)';
}


}

/// @nodoc
abstract mixin class $LocationVerificationResultCopyWith<$Res>  {
  factory $LocationVerificationResultCopyWith(LocationVerificationResult value, $Res Function(LocationVerificationResult) _then) = _$LocationVerificationResultCopyWithImpl;
@useResult
$Res call({
 bool isValid, String reason, double? distance, DateTime? verifiedAt, String? locationAddress
});




}
/// @nodoc
class _$LocationVerificationResultCopyWithImpl<$Res>
    implements $LocationVerificationResultCopyWith<$Res> {
  _$LocationVerificationResultCopyWithImpl(this._self, this._then);

  final LocationVerificationResult _self;
  final $Res Function(LocationVerificationResult) _then;

/// Create a copy of LocationVerificationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isValid = null,Object? reason = null,Object? distance = freezed,Object? verifiedAt = freezed,Object? locationAddress = freezed,}) {
  return _then(_self.copyWith(
isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,locationAddress: freezed == locationAddress ? _self.locationAddress : locationAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationVerificationResult].
extension LocationVerificationResultPatterns on LocationVerificationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationVerificationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationVerificationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationVerificationResult value)  $default,){
final _that = this;
switch (_that) {
case _LocationVerificationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationVerificationResult value)?  $default,){
final _that = this;
switch (_that) {
case _LocationVerificationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isValid,  String reason,  double? distance,  DateTime? verifiedAt,  String? locationAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationVerificationResult() when $default != null:
return $default(_that.isValid,_that.reason,_that.distance,_that.verifiedAt,_that.locationAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isValid,  String reason,  double? distance,  DateTime? verifiedAt,  String? locationAddress)  $default,) {final _that = this;
switch (_that) {
case _LocationVerificationResult():
return $default(_that.isValid,_that.reason,_that.distance,_that.verifiedAt,_that.locationAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isValid,  String reason,  double? distance,  DateTime? verifiedAt,  String? locationAddress)?  $default,) {final _that = this;
switch (_that) {
case _LocationVerificationResult() when $default != null:
return $default(_that.isValid,_that.reason,_that.distance,_that.verifiedAt,_that.locationAddress);case _:
  return null;

}
}

}

/// @nodoc


class _LocationVerificationResult implements LocationVerificationResult {
  const _LocationVerificationResult({required this.isValid, required this.reason, this.distance, this.verifiedAt, this.locationAddress});
  

/// 검증 성공 여부
@override final  bool isValid;
/// 검증 결과 메시지
@override final  String reason;
/// 캠페인 장소와의 거리 (미터 단위)
@override final  double? distance;
/// 검증 시간
@override final  DateTime? verifiedAt;
/// 캠페인 장소 주소
@override final  String? locationAddress;

/// Create a copy of LocationVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationVerificationResultCopyWith<_LocationVerificationResult> get copyWith => __$LocationVerificationResultCopyWithImpl<_LocationVerificationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationVerificationResult&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.locationAddress, locationAddress) || other.locationAddress == locationAddress));
}


@override
int get hashCode => Object.hash(runtimeType,isValid,reason,distance,verifiedAt,locationAddress);

@override
String toString() {
  return 'LocationVerificationResult(isValid: $isValid, reason: $reason, distance: $distance, verifiedAt: $verifiedAt, locationAddress: $locationAddress)';
}


}

/// @nodoc
abstract mixin class _$LocationVerificationResultCopyWith<$Res> implements $LocationVerificationResultCopyWith<$Res> {
  factory _$LocationVerificationResultCopyWith(_LocationVerificationResult value, $Res Function(_LocationVerificationResult) _then) = __$LocationVerificationResultCopyWithImpl;
@override @useResult
$Res call({
 bool isValid, String reason, double? distance, DateTime? verifiedAt, String? locationAddress
});




}
/// @nodoc
class __$LocationVerificationResultCopyWithImpl<$Res>
    implements _$LocationVerificationResultCopyWith<$Res> {
  __$LocationVerificationResultCopyWithImpl(this._self, this._then);

  final _LocationVerificationResult _self;
  final $Res Function(_LocationVerificationResult) _then;

/// Create a copy of LocationVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isValid = null,Object? reason = null,Object? distance = freezed,Object? verifiedAt = freezed,Object? locationAddress = freezed,}) {
  return _then(_LocationVerificationResult(
isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,locationAddress: freezed == locationAddress ? _self.locationAddress : locationAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
