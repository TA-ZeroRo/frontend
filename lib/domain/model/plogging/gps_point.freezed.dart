// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gps_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GpsPoint {

 double get lat; double get lng; DateTime get timestamp; double? get accuracy;
/// Create a copy of GpsPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GpsPointCopyWith<GpsPoint> get copyWith => _$GpsPointCopyWithImpl<GpsPoint>(this as GpsPoint, _$identity);

  /// Serializes this GpsPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GpsPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,timestamp,accuracy);

@override
String toString() {
  return 'GpsPoint(lat: $lat, lng: $lng, timestamp: $timestamp, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class $GpsPointCopyWith<$Res>  {
  factory $GpsPointCopyWith(GpsPoint value, $Res Function(GpsPoint) _then) = _$GpsPointCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, DateTime timestamp, double? accuracy
});




}
/// @nodoc
class _$GpsPointCopyWithImpl<$Res>
    implements $GpsPointCopyWith<$Res> {
  _$GpsPointCopyWithImpl(this._self, this._then);

  final GpsPoint _self;
  final $Res Function(GpsPoint) _then;

/// Create a copy of GpsPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? timestamp = null,Object? accuracy = freezed,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [GpsPoint].
extension GpsPointPatterns on GpsPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GpsPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GpsPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GpsPoint value)  $default,){
final _that = this;
switch (_that) {
case _GpsPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GpsPoint value)?  $default,){
final _that = this;
switch (_that) {
case _GpsPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime timestamp,  double? accuracy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GpsPoint() when $default != null:
return $default(_that.lat,_that.lng,_that.timestamp,_that.accuracy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime timestamp,  double? accuracy)  $default,) {final _that = this;
switch (_that) {
case _GpsPoint():
return $default(_that.lat,_that.lng,_that.timestamp,_that.accuracy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  DateTime timestamp,  double? accuracy)?  $default,) {final _that = this;
switch (_that) {
case _GpsPoint() when $default != null:
return $default(_that.lat,_that.lng,_that.timestamp,_that.accuracy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GpsPoint implements GpsPoint {
  const _GpsPoint({required this.lat, required this.lng, required this.timestamp, this.accuracy});
  factory _GpsPoint.fromJson(Map<String, dynamic> json) => _$GpsPointFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  DateTime timestamp;
@override final  double? accuracy;

/// Create a copy of GpsPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GpsPointCopyWith<_GpsPoint> get copyWith => __$GpsPointCopyWithImpl<_GpsPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GpsPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GpsPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,timestamp,accuracy);

@override
String toString() {
  return 'GpsPoint(lat: $lat, lng: $lng, timestamp: $timestamp, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class _$GpsPointCopyWith<$Res> implements $GpsPointCopyWith<$Res> {
  factory _$GpsPointCopyWith(_GpsPoint value, $Res Function(_GpsPoint) _then) = __$GpsPointCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, DateTime timestamp, double? accuracy
});




}
/// @nodoc
class __$GpsPointCopyWithImpl<$Res>
    implements _$GpsPointCopyWith<$Res> {
  __$GpsPointCopyWithImpl(this._self, this._then);

  final _GpsPoint _self;
  final $Res Function(_GpsPoint) _then;

/// Create a copy of GpsPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? timestamp = null,Object? accuracy = freezed,}) {
  return _then(_GpsPoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
