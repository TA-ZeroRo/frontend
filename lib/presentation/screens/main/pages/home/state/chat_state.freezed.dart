// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SimpleMessage {

 String get text; bool get isAI; DateTime get timestamp;
/// Create a copy of SimpleMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimpleMessageCopyWith<SimpleMessage> get copyWith => _$SimpleMessageCopyWithImpl<SimpleMessage>(this as SimpleMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimpleMessage&&(identical(other.text, text) || other.text == text)&&(identical(other.isAI, isAI) || other.isAI == isAI)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,text,isAI,timestamp);

@override
String toString() {
  return 'SimpleMessage(text: $text, isAI: $isAI, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $SimpleMessageCopyWith<$Res>  {
  factory $SimpleMessageCopyWith(SimpleMessage value, $Res Function(SimpleMessage) _then) = _$SimpleMessageCopyWithImpl;
@useResult
$Res call({
 String text, bool isAI, DateTime timestamp
});




}
/// @nodoc
class _$SimpleMessageCopyWithImpl<$Res>
    implements $SimpleMessageCopyWith<$Res> {
  _$SimpleMessageCopyWithImpl(this._self, this._then);

  final SimpleMessage _self;
  final $Res Function(SimpleMessage) _then;

/// Create a copy of SimpleMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? isAI = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isAI: null == isAI ? _self.isAI : isAI // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SimpleMessage].
extension SimpleMessagePatterns on SimpleMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimpleMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimpleMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimpleMessage value)  $default,){
final _that = this;
switch (_that) {
case _SimpleMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimpleMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SimpleMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  bool isAI,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimpleMessage() when $default != null:
return $default(_that.text,_that.isAI,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  bool isAI,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _SimpleMessage():
return $default(_that.text,_that.isAI,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  bool isAI,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _SimpleMessage() when $default != null:
return $default(_that.text,_that.isAI,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _SimpleMessage implements SimpleMessage {
  const _SimpleMessage({required this.text, required this.isAI, required this.timestamp});
  

@override final  String text;
@override final  bool isAI;
@override final  DateTime timestamp;

/// Create a copy of SimpleMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimpleMessageCopyWith<_SimpleMessage> get copyWith => __$SimpleMessageCopyWithImpl<_SimpleMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimpleMessage&&(identical(other.text, text) || other.text == text)&&(identical(other.isAI, isAI) || other.isAI == isAI)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,text,isAI,timestamp);

@override
String toString() {
  return 'SimpleMessage(text: $text, isAI: $isAI, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$SimpleMessageCopyWith<$Res> implements $SimpleMessageCopyWith<$Res> {
  factory _$SimpleMessageCopyWith(_SimpleMessage value, $Res Function(_SimpleMessage) _then) = __$SimpleMessageCopyWithImpl;
@override @useResult
$Res call({
 String text, bool isAI, DateTime timestamp
});




}
/// @nodoc
class __$SimpleMessageCopyWithImpl<$Res>
    implements _$SimpleMessageCopyWith<$Res> {
  __$SimpleMessageCopyWithImpl(this._self, this._then);

  final _SimpleMessage _self;
  final $Res Function(_SimpleMessage) _then;

/// Create a copy of SimpleMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? isAI = null,Object? timestamp = null,}) {
  return _then(_SimpleMessage(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isAI: null == isAI ? _self.isAI : isAI // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$ChatState {

 List<SimpleMessage> get messages;// 전체 채팅 메시지 히스토리
 bool get isLoading;// 타이핑 인디케이터 표시 여부
 String get inputText;// 입력 필드 텍스트
 bool get isFullChatOpen;// 전체 화면 채팅 오버레이 표시 여부
 String? get error;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.inputText, inputText) || other.inputText == inputText)&&(identical(other.isFullChatOpen, isFullChatOpen) || other.isFullChatOpen == isFullChatOpen)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),isLoading,inputText,isFullChatOpen,error);

@override
String toString() {
  return 'ChatState(messages: $messages, isLoading: $isLoading, inputText: $inputText, isFullChatOpen: $isFullChatOpen, error: $error)';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 List<SimpleMessage> messages, bool isLoading, String inputText, bool isFullChatOpen, String? error
});




}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? isLoading = null,Object? inputText = null,Object? isFullChatOpen = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<SimpleMessage>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,isFullChatOpen: null == isFullChatOpen ? _self.isFullChatOpen : isFullChatOpen // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatState value)  $default,){
final _that = this;
switch (_that) {
case _ChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SimpleMessage> messages,  bool isLoading,  String inputText,  bool isFullChatOpen,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.isLoading,_that.inputText,_that.isFullChatOpen,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SimpleMessage> messages,  bool isLoading,  String inputText,  bool isFullChatOpen,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ChatState():
return $default(_that.messages,_that.isLoading,_that.inputText,_that.isFullChatOpen,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SimpleMessage> messages,  bool isLoading,  String inputText,  bool isFullChatOpen,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.isLoading,_that.inputText,_that.isFullChatOpen,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ChatState implements ChatState {
  const _ChatState({final  List<SimpleMessage> messages = const [], this.isLoading = false, this.inputText = '', this.isFullChatOpen = false, this.error}): _messages = messages;
  

 final  List<SimpleMessage> _messages;
@override@JsonKey() List<SimpleMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

// 전체 채팅 메시지 히스토리
@override@JsonKey() final  bool isLoading;
// 타이핑 인디케이터 표시 여부
@override@JsonKey() final  String inputText;
// 입력 필드 텍스트
@override@JsonKey() final  bool isFullChatOpen;
// 전체 화면 채팅 오버레이 표시 여부
@override final  String? error;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.inputText, inputText) || other.inputText == inputText)&&(identical(other.isFullChatOpen, isFullChatOpen) || other.isFullChatOpen == isFullChatOpen)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),isLoading,inputText,isFullChatOpen,error);

@override
String toString() {
  return 'ChatState(messages: $messages, isLoading: $isLoading, inputText: $inputText, isFullChatOpen: $isFullChatOpen, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<SimpleMessage> messages, bool isLoading, String inputText, bool isFullChatOpen, String? error
});




}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? isLoading = null,Object? inputText = null,Object? isFullChatOpen = null,Object? error = freezed,}) {
  return _then(_ChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<SimpleMessage>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,isFullChatOpen: null == isFullChatOpen ? _self.isFullChatOpen : isFullChatOpen // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
