// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plogging_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PloggingRoute {

 int get sessionId; String get userId; int get intensityLevel; List<GpsPoint> get routePoints; DateTime get createdAt;
/// Create a copy of PloggingRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PloggingRouteCopyWith<PloggingRoute> get copyWith => _$PloggingRouteCopyWithImpl<PloggingRoute>(this as PloggingRoute, _$identity);

  /// Serializes this PloggingRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PloggingRoute&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.intensityLevel, intensityLevel) || other.intensityLevel == intensityLevel)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,userId,intensityLevel,const DeepCollectionEquality().hash(routePoints),createdAt);

@override
String toString() {
  return 'PloggingRoute(sessionId: $sessionId, userId: $userId, intensityLevel: $intensityLevel, routePoints: $routePoints, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PloggingRouteCopyWith<$Res>  {
  factory $PloggingRouteCopyWith(PloggingRoute value, $Res Function(PloggingRoute) _then) = _$PloggingRouteCopyWithImpl;
@useResult
$Res call({
 int sessionId, String userId, int intensityLevel, List<GpsPoint> routePoints, DateTime createdAt
});




}
/// @nodoc
class _$PloggingRouteCopyWithImpl<$Res>
    implements $PloggingRouteCopyWith<$Res> {
  _$PloggingRouteCopyWithImpl(this._self, this._then);

  final PloggingRoute _self;
  final $Res Function(PloggingRoute) _then;

/// Create a copy of PloggingRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? userId = null,Object? intensityLevel = null,Object? routePoints = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,intensityLevel: null == intensityLevel ? _self.intensityLevel : intensityLevel // ignore: cast_nullable_to_non_nullable
as int,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<GpsPoint>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PloggingRoute].
extension PloggingRoutePatterns on PloggingRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PloggingRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PloggingRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PloggingRoute value)  $default,){
final _that = this;
switch (_that) {
case _PloggingRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PloggingRoute value)?  $default,){
final _that = this;
switch (_that) {
case _PloggingRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sessionId,  String userId,  int intensityLevel,  List<GpsPoint> routePoints,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PloggingRoute() when $default != null:
return $default(_that.sessionId,_that.userId,_that.intensityLevel,_that.routePoints,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sessionId,  String userId,  int intensityLevel,  List<GpsPoint> routePoints,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PloggingRoute():
return $default(_that.sessionId,_that.userId,_that.intensityLevel,_that.routePoints,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sessionId,  String userId,  int intensityLevel,  List<GpsPoint> routePoints,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PloggingRoute() when $default != null:
return $default(_that.sessionId,_that.userId,_that.intensityLevel,_that.routePoints,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PloggingRoute implements PloggingRoute {
  const _PloggingRoute({required this.sessionId, required this.userId, required this.intensityLevel, required final  List<GpsPoint> routePoints, required this.createdAt}): _routePoints = routePoints;
  factory _PloggingRoute.fromJson(Map<String, dynamic> json) => _$PloggingRouteFromJson(json);

@override final  int sessionId;
@override final  String userId;
@override final  int intensityLevel;
 final  List<GpsPoint> _routePoints;
@override List<GpsPoint> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override final  DateTime createdAt;

/// Create a copy of PloggingRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PloggingRouteCopyWith<_PloggingRoute> get copyWith => __$PloggingRouteCopyWithImpl<_PloggingRoute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PloggingRouteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PloggingRoute&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.intensityLevel, intensityLevel) || other.intensityLevel == intensityLevel)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,userId,intensityLevel,const DeepCollectionEquality().hash(_routePoints),createdAt);

@override
String toString() {
  return 'PloggingRoute(sessionId: $sessionId, userId: $userId, intensityLevel: $intensityLevel, routePoints: $routePoints, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PloggingRouteCopyWith<$Res> implements $PloggingRouteCopyWith<$Res> {
  factory _$PloggingRouteCopyWith(_PloggingRoute value, $Res Function(_PloggingRoute) _then) = __$PloggingRouteCopyWithImpl;
@override @useResult
$Res call({
 int sessionId, String userId, int intensityLevel, List<GpsPoint> routePoints, DateTime createdAt
});




}
/// @nodoc
class __$PloggingRouteCopyWithImpl<$Res>
    implements _$PloggingRouteCopyWith<$Res> {
  __$PloggingRouteCopyWithImpl(this._self, this._then);

  final _PloggingRoute _self;
  final $Res Function(_PloggingRoute) _then;

/// Create a copy of PloggingRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? userId = null,Object? intensityLevel = null,Object? routePoints = null,Object? createdAt = null,}) {
  return _then(_PloggingRoute(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,intensityLevel: null == intensityLevel ? _self.intensityLevel : intensityLevel // ignore: cast_nullable_to_non_nullable
as int,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<GpsPoint>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$MapRoutesResponse {

 List<PloggingRoute> get routes; int get totalCount;
/// Create a copy of MapRoutesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapRoutesResponseCopyWith<MapRoutesResponse> get copyWith => _$MapRoutesResponseCopyWithImpl<MapRoutesResponse>(this as MapRoutesResponse, _$identity);

  /// Serializes this MapRoutesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapRoutesResponse&&const DeepCollectionEquality().equals(other.routes, routes)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(routes),totalCount);

@override
String toString() {
  return 'MapRoutesResponse(routes: $routes, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $MapRoutesResponseCopyWith<$Res>  {
  factory $MapRoutesResponseCopyWith(MapRoutesResponse value, $Res Function(MapRoutesResponse) _then) = _$MapRoutesResponseCopyWithImpl;
@useResult
$Res call({
 List<PloggingRoute> routes, int totalCount
});




}
/// @nodoc
class _$MapRoutesResponseCopyWithImpl<$Res>
    implements $MapRoutesResponseCopyWith<$Res> {
  _$MapRoutesResponseCopyWithImpl(this._self, this._then);

  final MapRoutesResponse _self;
  final $Res Function(MapRoutesResponse) _then;

/// Create a copy of MapRoutesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routes = null,Object? totalCount = null,}) {
  return _then(_self.copyWith(
routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<PloggingRoute>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MapRoutesResponse].
extension MapRoutesResponsePatterns on MapRoutesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapRoutesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapRoutesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapRoutesResponse value)  $default,){
final _that = this;
switch (_that) {
case _MapRoutesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapRoutesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MapRoutesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PloggingRoute> routes,  int totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapRoutesResponse() when $default != null:
return $default(_that.routes,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PloggingRoute> routes,  int totalCount)  $default,) {final _that = this;
switch (_that) {
case _MapRoutesResponse():
return $default(_that.routes,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PloggingRoute> routes,  int totalCount)?  $default,) {final _that = this;
switch (_that) {
case _MapRoutesResponse() when $default != null:
return $default(_that.routes,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapRoutesResponse implements MapRoutesResponse {
  const _MapRoutesResponse({required final  List<PloggingRoute> routes, required this.totalCount}): _routes = routes;
  factory _MapRoutesResponse.fromJson(Map<String, dynamic> json) => _$MapRoutesResponseFromJson(json);

 final  List<PloggingRoute> _routes;
@override List<PloggingRoute> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}

@override final  int totalCount;

/// Create a copy of MapRoutesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapRoutesResponseCopyWith<_MapRoutesResponse> get copyWith => __$MapRoutesResponseCopyWithImpl<_MapRoutesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapRoutesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapRoutesResponse&&const DeepCollectionEquality().equals(other._routes, _routes)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_routes),totalCount);

@override
String toString() {
  return 'MapRoutesResponse(routes: $routes, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$MapRoutesResponseCopyWith<$Res> implements $MapRoutesResponseCopyWith<$Res> {
  factory _$MapRoutesResponseCopyWith(_MapRoutesResponse value, $Res Function(_MapRoutesResponse) _then) = __$MapRoutesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PloggingRoute> routes, int totalCount
});




}
/// @nodoc
class __$MapRoutesResponseCopyWithImpl<$Res>
    implements _$MapRoutesResponseCopyWith<$Res> {
  __$MapRoutesResponseCopyWithImpl(this._self, this._then);

  final _MapRoutesResponse _self;
  final $Res Function(_MapRoutesResponse) _then;

/// Create a copy of MapRoutesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routes = null,Object? totalCount = null,}) {
  return _then(_MapRoutesResponse(
routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<PloggingRoute>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
