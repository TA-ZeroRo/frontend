// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgentState {

 AgentType get currentAgent; AgentStyle get currentStyle;
/// Create a copy of AgentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentStateCopyWith<AgentState> get copyWith => _$AgentStateCopyWithImpl<AgentState>(this as AgentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentState&&(identical(other.currentAgent, currentAgent) || other.currentAgent == currentAgent)&&(identical(other.currentStyle, currentStyle) || other.currentStyle == currentStyle));
}


@override
int get hashCode => Object.hash(runtimeType,currentAgent,currentStyle);

@override
String toString() {
  return 'AgentState(currentAgent: $currentAgent, currentStyle: $currentStyle)';
}


}

/// @nodoc
abstract mixin class $AgentStateCopyWith<$Res>  {
  factory $AgentStateCopyWith(AgentState value, $Res Function(AgentState) _then) = _$AgentStateCopyWithImpl;
@useResult
$Res call({
 AgentType currentAgent, AgentStyle currentStyle
});




}
/// @nodoc
class _$AgentStateCopyWithImpl<$Res>
    implements $AgentStateCopyWith<$Res> {
  _$AgentStateCopyWithImpl(this._self, this._then);

  final AgentState _self;
  final $Res Function(AgentState) _then;

/// Create a copy of AgentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentAgent = null,Object? currentStyle = null,}) {
  return _then(_self.copyWith(
currentAgent: null == currentAgent ? _self.currentAgent : currentAgent // ignore: cast_nullable_to_non_nullable
as AgentType,currentStyle: null == currentStyle ? _self.currentStyle : currentStyle // ignore: cast_nullable_to_non_nullable
as AgentStyle,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentState].
extension AgentStatePatterns on AgentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentState value)  $default,){
final _that = this;
switch (_that) {
case _AgentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentState value)?  $default,){
final _that = this;
switch (_that) {
case _AgentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AgentType currentAgent,  AgentStyle currentStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentState() when $default != null:
return $default(_that.currentAgent,_that.currentStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AgentType currentAgent,  AgentStyle currentStyle)  $default,) {final _that = this;
switch (_that) {
case _AgentState():
return $default(_that.currentAgent,_that.currentStyle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AgentType currentAgent,  AgentStyle currentStyle)?  $default,) {final _that = this;
switch (_that) {
case _AgentState() when $default != null:
return $default(_that.currentAgent,_that.currentStyle);case _:
  return null;

}
}

}

/// @nodoc


class _AgentState implements AgentState {
  const _AgentState({this.currentAgent = AgentType.planetZeroro, this.currentStyle = AgentStyle.friendly});
  

@override@JsonKey() final  AgentType currentAgent;
@override@JsonKey() final  AgentStyle currentStyle;

/// Create a copy of AgentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentStateCopyWith<_AgentState> get copyWith => __$AgentStateCopyWithImpl<_AgentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentState&&(identical(other.currentAgent, currentAgent) || other.currentAgent == currentAgent)&&(identical(other.currentStyle, currentStyle) || other.currentStyle == currentStyle));
}


@override
int get hashCode => Object.hash(runtimeType,currentAgent,currentStyle);

@override
String toString() {
  return 'AgentState(currentAgent: $currentAgent, currentStyle: $currentStyle)';
}


}

/// @nodoc
abstract mixin class _$AgentStateCopyWith<$Res> implements $AgentStateCopyWith<$Res> {
  factory _$AgentStateCopyWith(_AgentState value, $Res Function(_AgentState) _then) = __$AgentStateCopyWithImpl;
@override @useResult
$Res call({
 AgentType currentAgent, AgentStyle currentStyle
});




}
/// @nodoc
class __$AgentStateCopyWithImpl<$Res>
    implements _$AgentStateCopyWith<$Res> {
  __$AgentStateCopyWithImpl(this._self, this._then);

  final _AgentState _self;
  final $Res Function(_AgentState) _then;

/// Create a copy of AgentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentAgent = null,Object? currentStyle = null,}) {
  return _then(_AgentState(
currentAgent: null == currentAgent ? _self.currentAgent : currentAgent // ignore: cast_nullable_to_non_nullable
as AgentType,currentStyle: null == currentStyle ? _self.currentStyle : currentStyle // ignore: cast_nullable_to_non_nullable
as AgentStyle,
  ));
}


}

// dart format on
