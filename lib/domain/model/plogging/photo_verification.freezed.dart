// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIVerificationResult {

 bool get isValid; double get confidence; List<String> get detectedItems; String get reason;
/// Create a copy of AIVerificationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIVerificationResultCopyWith<AIVerificationResult> get copyWith => _$AIVerificationResultCopyWithImpl<AIVerificationResult>(this as AIVerificationResult, _$identity);

  /// Serializes this AIVerificationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIVerificationResult&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.detectedItems, detectedItems)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isValid,confidence,const DeepCollectionEquality().hash(detectedItems),reason);

@override
String toString() {
  return 'AIVerificationResult(isValid: $isValid, confidence: $confidence, detectedItems: $detectedItems, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AIVerificationResultCopyWith<$Res>  {
  factory $AIVerificationResultCopyWith(AIVerificationResult value, $Res Function(AIVerificationResult) _then) = _$AIVerificationResultCopyWithImpl;
@useResult
$Res call({
 bool isValid, double confidence, List<String> detectedItems, String reason
});




}
/// @nodoc
class _$AIVerificationResultCopyWithImpl<$Res>
    implements $AIVerificationResultCopyWith<$Res> {
  _$AIVerificationResultCopyWithImpl(this._self, this._then);

  final AIVerificationResult _self;
  final $Res Function(AIVerificationResult) _then;

/// Create a copy of AIVerificationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isValid = null,Object? confidence = null,Object? detectedItems = null,Object? reason = null,}) {
  return _then(_self.copyWith(
isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,detectedItems: null == detectedItems ? _self.detectedItems : detectedItems // ignore: cast_nullable_to_non_nullable
as List<String>,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AIVerificationResult].
extension AIVerificationResultPatterns on AIVerificationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIVerificationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIVerificationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIVerificationResult value)  $default,){
final _that = this;
switch (_that) {
case _AIVerificationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIVerificationResult value)?  $default,){
final _that = this;
switch (_that) {
case _AIVerificationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isValid,  double confidence,  List<String> detectedItems,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIVerificationResult() when $default != null:
return $default(_that.isValid,_that.confidence,_that.detectedItems,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isValid,  double confidence,  List<String> detectedItems,  String reason)  $default,) {final _that = this;
switch (_that) {
case _AIVerificationResult():
return $default(_that.isValid,_that.confidence,_that.detectedItems,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isValid,  double confidence,  List<String> detectedItems,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _AIVerificationResult() when $default != null:
return $default(_that.isValid,_that.confidence,_that.detectedItems,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIVerificationResult implements AIVerificationResult {
  const _AIVerificationResult({required this.isValid, required this.confidence, final  List<String> detectedItems = const [], required this.reason}): _detectedItems = detectedItems;
  factory _AIVerificationResult.fromJson(Map<String, dynamic> json) => _$AIVerificationResultFromJson(json);

@override final  bool isValid;
@override final  double confidence;
 final  List<String> _detectedItems;
@override@JsonKey() List<String> get detectedItems {
  if (_detectedItems is EqualUnmodifiableListView) return _detectedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detectedItems);
}

@override final  String reason;

/// Create a copy of AIVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIVerificationResultCopyWith<_AIVerificationResult> get copyWith => __$AIVerificationResultCopyWithImpl<_AIVerificationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIVerificationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIVerificationResult&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other._detectedItems, _detectedItems)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isValid,confidence,const DeepCollectionEquality().hash(_detectedItems),reason);

@override
String toString() {
  return 'AIVerificationResult(isValid: $isValid, confidence: $confidence, detectedItems: $detectedItems, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$AIVerificationResultCopyWith<$Res> implements $AIVerificationResultCopyWith<$Res> {
  factory _$AIVerificationResultCopyWith(_AIVerificationResult value, $Res Function(_AIVerificationResult) _then) = __$AIVerificationResultCopyWithImpl;
@override @useResult
$Res call({
 bool isValid, double confidence, List<String> detectedItems, String reason
});




}
/// @nodoc
class __$AIVerificationResultCopyWithImpl<$Res>
    implements _$AIVerificationResultCopyWith<$Res> {
  __$AIVerificationResultCopyWithImpl(this._self, this._then);

  final _AIVerificationResult _self;
  final $Res Function(_AIVerificationResult) _then;

/// Create a copy of AIVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isValid = null,Object? confidence = null,Object? detectedItems = null,Object? reason = null,}) {
  return _then(_AIVerificationResult(
isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,detectedItems: null == detectedItems ? _self._detectedItems : detectedItems // ignore: cast_nullable_to_non_nullable
as List<String>,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PhotoVerificationResponse {

 int get id; int get sessionId; VerificationStatus get verificationStatus; double? get aiConfidence; AIVerificationResult? get aiResult; int get pointsEarned; DateTime get verifiedAt;
/// Create a copy of PhotoVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoVerificationResponseCopyWith<PhotoVerificationResponse> get copyWith => _$PhotoVerificationResponseCopyWithImpl<PhotoVerificationResponse>(this as PhotoVerificationResponse, _$identity);

  /// Serializes this PhotoVerificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoVerificationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.aiResult, aiResult) || other.aiResult == aiResult)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,verificationStatus,aiConfidence,aiResult,pointsEarned,verifiedAt);

@override
String toString() {
  return 'PhotoVerificationResponse(id: $id, sessionId: $sessionId, verificationStatus: $verificationStatus, aiConfidence: $aiConfidence, aiResult: $aiResult, pointsEarned: $pointsEarned, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class $PhotoVerificationResponseCopyWith<$Res>  {
  factory $PhotoVerificationResponseCopyWith(PhotoVerificationResponse value, $Res Function(PhotoVerificationResponse) _then) = _$PhotoVerificationResponseCopyWithImpl;
@useResult
$Res call({
 int id, int sessionId, VerificationStatus verificationStatus, double? aiConfidence, AIVerificationResult? aiResult, int pointsEarned, DateTime verifiedAt
});


$AIVerificationResultCopyWith<$Res>? get aiResult;

}
/// @nodoc
class _$PhotoVerificationResponseCopyWithImpl<$Res>
    implements $PhotoVerificationResponseCopyWith<$Res> {
  _$PhotoVerificationResponseCopyWithImpl(this._self, this._then);

  final PhotoVerificationResponse _self;
  final $Res Function(PhotoVerificationResponse) _then;

/// Create a copy of PhotoVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? verificationStatus = null,Object? aiConfidence = freezed,Object? aiResult = freezed,Object? pointsEarned = null,Object? verifiedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,aiConfidence: freezed == aiConfidence ? _self.aiConfidence : aiConfidence // ignore: cast_nullable_to_non_nullable
as double?,aiResult: freezed == aiResult ? _self.aiResult : aiResult // ignore: cast_nullable_to_non_nullable
as AIVerificationResult?,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,verifiedAt: null == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PhotoVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AIVerificationResultCopyWith<$Res>? get aiResult {
    if (_self.aiResult == null) {
    return null;
  }

  return $AIVerificationResultCopyWith<$Res>(_self.aiResult!, (value) {
    return _then(_self.copyWith(aiResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [PhotoVerificationResponse].
extension PhotoVerificationResponsePatterns on PhotoVerificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoVerificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoVerificationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoVerificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _PhotoVerificationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoVerificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoVerificationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int sessionId,  VerificationStatus verificationStatus,  double? aiConfidence,  AIVerificationResult? aiResult,  int pointsEarned,  DateTime verifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoVerificationResponse() when $default != null:
return $default(_that.id,_that.sessionId,_that.verificationStatus,_that.aiConfidence,_that.aiResult,_that.pointsEarned,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int sessionId,  VerificationStatus verificationStatus,  double? aiConfidence,  AIVerificationResult? aiResult,  int pointsEarned,  DateTime verifiedAt)  $default,) {final _that = this;
switch (_that) {
case _PhotoVerificationResponse():
return $default(_that.id,_that.sessionId,_that.verificationStatus,_that.aiConfidence,_that.aiResult,_that.pointsEarned,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int sessionId,  VerificationStatus verificationStatus,  double? aiConfidence,  AIVerificationResult? aiResult,  int pointsEarned,  DateTime verifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _PhotoVerificationResponse() when $default != null:
return $default(_that.id,_that.sessionId,_that.verificationStatus,_that.aiConfidence,_that.aiResult,_that.pointsEarned,_that.verifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoVerificationResponse implements PhotoVerificationResponse {
  const _PhotoVerificationResponse({required this.id, required this.sessionId, required this.verificationStatus, this.aiConfidence, this.aiResult, this.pointsEarned = 0, required this.verifiedAt});
  factory _PhotoVerificationResponse.fromJson(Map<String, dynamic> json) => _$PhotoVerificationResponseFromJson(json);

@override final  int id;
@override final  int sessionId;
@override final  VerificationStatus verificationStatus;
@override final  double? aiConfidence;
@override final  AIVerificationResult? aiResult;
@override@JsonKey() final  int pointsEarned;
@override final  DateTime verifiedAt;

/// Create a copy of PhotoVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoVerificationResponseCopyWith<_PhotoVerificationResponse> get copyWith => __$PhotoVerificationResponseCopyWithImpl<_PhotoVerificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoVerificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoVerificationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.aiResult, aiResult) || other.aiResult == aiResult)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,verificationStatus,aiConfidence,aiResult,pointsEarned,verifiedAt);

@override
String toString() {
  return 'PhotoVerificationResponse(id: $id, sessionId: $sessionId, verificationStatus: $verificationStatus, aiConfidence: $aiConfidence, aiResult: $aiResult, pointsEarned: $pointsEarned, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class _$PhotoVerificationResponseCopyWith<$Res> implements $PhotoVerificationResponseCopyWith<$Res> {
  factory _$PhotoVerificationResponseCopyWith(_PhotoVerificationResponse value, $Res Function(_PhotoVerificationResponse) _then) = __$PhotoVerificationResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, int sessionId, VerificationStatus verificationStatus, double? aiConfidence, AIVerificationResult? aiResult, int pointsEarned, DateTime verifiedAt
});


@override $AIVerificationResultCopyWith<$Res>? get aiResult;

}
/// @nodoc
class __$PhotoVerificationResponseCopyWithImpl<$Res>
    implements _$PhotoVerificationResponseCopyWith<$Res> {
  __$PhotoVerificationResponseCopyWithImpl(this._self, this._then);

  final _PhotoVerificationResponse _self;
  final $Res Function(_PhotoVerificationResponse) _then;

/// Create a copy of PhotoVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? verificationStatus = null,Object? aiConfidence = freezed,Object? aiResult = freezed,Object? pointsEarned = null,Object? verifiedAt = null,}) {
  return _then(_PhotoVerificationResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,aiConfidence: freezed == aiConfidence ? _self.aiConfidence : aiConfidence // ignore: cast_nullable_to_non_nullable
as double?,aiResult: freezed == aiResult ? _self.aiResult : aiResult // ignore: cast_nullable_to_non_nullable
as AIVerificationResult?,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,verifiedAt: null == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PhotoVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AIVerificationResultCopyWith<$Res>? get aiResult {
    if (_self.aiResult == null) {
    return null;
  }

  return $AIVerificationResultCopyWith<$Res>(_self.aiResult!, (value) {
    return _then(_self.copyWith(aiResult: value));
  });
}
}

// dart format on
