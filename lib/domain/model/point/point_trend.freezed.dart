// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point_trend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointTrendDataPoint {

 DateTime get date; int get totalPoints;
/// Create a copy of PointTrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointTrendDataPointCopyWith<PointTrendDataPoint> get copyWith => _$PointTrendDataPointCopyWithImpl<PointTrendDataPoint>(this as PointTrendDataPoint, _$identity);

  /// Serializes this PointTrendDataPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointTrendDataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalPoints);

@override
String toString() {
  return 'PointTrendDataPoint(date: $date, totalPoints: $totalPoints)';
}


}

/// @nodoc
abstract mixin class $PointTrendDataPointCopyWith<$Res>  {
  factory $PointTrendDataPointCopyWith(PointTrendDataPoint value, $Res Function(PointTrendDataPoint) _then) = _$PointTrendDataPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, int totalPoints
});




}
/// @nodoc
class _$PointTrendDataPointCopyWithImpl<$Res>
    implements $PointTrendDataPointCopyWith<$Res> {
  _$PointTrendDataPointCopyWithImpl(this._self, this._then);

  final PointTrendDataPoint _self;
  final $Res Function(PointTrendDataPoint) _then;

/// Create a copy of PointTrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalPoints = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PointTrendDataPoint].
extension PointTrendDataPointPatterns on PointTrendDataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointTrendDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointTrendDataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointTrendDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _PointTrendDataPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointTrendDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _PointTrendDataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int totalPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointTrendDataPoint() when $default != null:
return $default(_that.date,_that.totalPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int totalPoints)  $default,) {final _that = this;
switch (_that) {
case _PointTrendDataPoint():
return $default(_that.date,_that.totalPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int totalPoints)?  $default,) {final _that = this;
switch (_that) {
case _PointTrendDataPoint() when $default != null:
return $default(_that.date,_that.totalPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointTrendDataPoint implements PointTrendDataPoint {
  const _PointTrendDataPoint({required this.date, required this.totalPoints});
  factory _PointTrendDataPoint.fromJson(Map<String, dynamic> json) => _$PointTrendDataPointFromJson(json);

@override final  DateTime date;
@override final  int totalPoints;

/// Create a copy of PointTrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointTrendDataPointCopyWith<_PointTrendDataPoint> get copyWith => __$PointTrendDataPointCopyWithImpl<_PointTrendDataPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointTrendDataPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointTrendDataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalPoints);

@override
String toString() {
  return 'PointTrendDataPoint(date: $date, totalPoints: $totalPoints)';
}


}

/// @nodoc
abstract mixin class _$PointTrendDataPointCopyWith<$Res> implements $PointTrendDataPointCopyWith<$Res> {
  factory _$PointTrendDataPointCopyWith(_PointTrendDataPoint value, $Res Function(_PointTrendDataPoint) _then) = __$PointTrendDataPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int totalPoints
});




}
/// @nodoc
class __$PointTrendDataPointCopyWithImpl<$Res>
    implements _$PointTrendDataPointCopyWith<$Res> {
  __$PointTrendDataPointCopyWithImpl(this._self, this._then);

  final _PointTrendDataPoint _self;
  final $Res Function(_PointTrendDataPoint) _then;

/// Create a copy of PointTrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalPoints = null,}) {
  return _then(_PointTrendDataPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PointTrend {

 String get userId; int get days; List<PointTrendDataPoint> get data;
/// Create a copy of PointTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointTrendCopyWith<PointTrend> get copyWith => _$PointTrendCopyWithImpl<PointTrend>(this as PointTrend, _$identity);

  /// Serializes this PointTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointTrend&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.days, days) || other.days == days)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,days,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PointTrend(userId: $userId, days: $days, data: $data)';
}


}

/// @nodoc
abstract mixin class $PointTrendCopyWith<$Res>  {
  factory $PointTrendCopyWith(PointTrend value, $Res Function(PointTrend) _then) = _$PointTrendCopyWithImpl;
@useResult
$Res call({
 String userId, int days, List<PointTrendDataPoint> data
});




}
/// @nodoc
class _$PointTrendCopyWithImpl<$Res>
    implements $PointTrendCopyWith<$Res> {
  _$PointTrendCopyWithImpl(this._self, this._then);

  final PointTrend _self;
  final $Res Function(PointTrend) _then;

/// Create a copy of PointTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? days = null,Object? data = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<PointTrendDataPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PointTrend].
extension PointTrendPatterns on PointTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointTrend value)  $default,){
final _that = this;
switch (_that) {
case _PointTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointTrend value)?  $default,){
final _that = this;
switch (_that) {
case _PointTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int days,  List<PointTrendDataPoint> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointTrend() when $default != null:
return $default(_that.userId,_that.days,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int days,  List<PointTrendDataPoint> data)  $default,) {final _that = this;
switch (_that) {
case _PointTrend():
return $default(_that.userId,_that.days,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int days,  List<PointTrendDataPoint> data)?  $default,) {final _that = this;
switch (_that) {
case _PointTrend() when $default != null:
return $default(_that.userId,_that.days,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointTrend implements PointTrend {
  const _PointTrend({required this.userId, required this.days, required final  List<PointTrendDataPoint> data}): _data = data;
  factory _PointTrend.fromJson(Map<String, dynamic> json) => _$PointTrendFromJson(json);

@override final  String userId;
@override final  int days;
 final  List<PointTrendDataPoint> _data;
@override List<PointTrendDataPoint> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of PointTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointTrendCopyWith<_PointTrend> get copyWith => __$PointTrendCopyWithImpl<_PointTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointTrend&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.days, days) || other.days == days)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,days,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'PointTrend(userId: $userId, days: $days, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PointTrendCopyWith<$Res> implements $PointTrendCopyWith<$Res> {
  factory _$PointTrendCopyWith(_PointTrend value, $Res Function(_PointTrend) _then) = __$PointTrendCopyWithImpl;
@override @useResult
$Res call({
 String userId, int days, List<PointTrendDataPoint> data
});




}
/// @nodoc
class __$PointTrendCopyWithImpl<$Res>
    implements _$PointTrendCopyWith<$Res> {
  __$PointTrendCopyWithImpl(this._self, this._then);

  final _PointTrend _self;
  final $Res Function(_PointTrend) _then;

/// Create a copy of PointTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? days = null,Object? data = null,}) {
  return _then(_PointTrend(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<PointTrendDataPoint>,
  ));
}


}

// dart format on
