// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyReport {

 String get id; String get userId; String get username; DateTime get startDate; DateTime get endDate; List<String> get campaignList;// 신청한 캠페인 목록
 int get dailyMissionCompletedCount; int get totalDailyMissions; int get monthlyPointsEarned;// 월간 획득 포인트
 int? get previousMonthPoints;// 저번달 포인트
 String? get comparisonMessage; String? get recommendationMessage; DateTime get createdAt;
/// Create a copy of WeeklyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyReportCopyWith<WeeklyReport> get copyWith => _$WeeklyReportCopyWithImpl<WeeklyReport>(this as WeeklyReport, _$identity);

  /// Serializes this WeeklyReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyReport&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.campaignList, campaignList)&&(identical(other.dailyMissionCompletedCount, dailyMissionCompletedCount) || other.dailyMissionCompletedCount == dailyMissionCompletedCount)&&(identical(other.totalDailyMissions, totalDailyMissions) || other.totalDailyMissions == totalDailyMissions)&&(identical(other.monthlyPointsEarned, monthlyPointsEarned) || other.monthlyPointsEarned == monthlyPointsEarned)&&(identical(other.previousMonthPoints, previousMonthPoints) || other.previousMonthPoints == previousMonthPoints)&&(identical(other.comparisonMessage, comparisonMessage) || other.comparisonMessage == comparisonMessage)&&(identical(other.recommendationMessage, recommendationMessage) || other.recommendationMessage == recommendationMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,startDate,endDate,const DeepCollectionEquality().hash(campaignList),dailyMissionCompletedCount,totalDailyMissions,monthlyPointsEarned,previousMonthPoints,comparisonMessage,recommendationMessage,createdAt);

@override
String toString() {
  return 'WeeklyReport(id: $id, userId: $userId, username: $username, startDate: $startDate, endDate: $endDate, campaignList: $campaignList, dailyMissionCompletedCount: $dailyMissionCompletedCount, totalDailyMissions: $totalDailyMissions, monthlyPointsEarned: $monthlyPointsEarned, previousMonthPoints: $previousMonthPoints, comparisonMessage: $comparisonMessage, recommendationMessage: $recommendationMessage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WeeklyReportCopyWith<$Res>  {
  factory $WeeklyReportCopyWith(WeeklyReport value, $Res Function(WeeklyReport) _then) = _$WeeklyReportCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String username, DateTime startDate, DateTime endDate, List<String> campaignList, int dailyMissionCompletedCount, int totalDailyMissions, int monthlyPointsEarned, int? previousMonthPoints, String? comparisonMessage, String? recommendationMessage, DateTime createdAt
});




}
/// @nodoc
class _$WeeklyReportCopyWithImpl<$Res>
    implements $WeeklyReportCopyWith<$Res> {
  _$WeeklyReportCopyWithImpl(this._self, this._then);

  final WeeklyReport _self;
  final $Res Function(WeeklyReport) _then;

/// Create a copy of WeeklyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? username = null,Object? startDate = null,Object? endDate = null,Object? campaignList = null,Object? dailyMissionCompletedCount = null,Object? totalDailyMissions = null,Object? monthlyPointsEarned = null,Object? previousMonthPoints = freezed,Object? comparisonMessage = freezed,Object? recommendationMessage = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,campaignList: null == campaignList ? _self.campaignList : campaignList // ignore: cast_nullable_to_non_nullable
as List<String>,dailyMissionCompletedCount: null == dailyMissionCompletedCount ? _self.dailyMissionCompletedCount : dailyMissionCompletedCount // ignore: cast_nullable_to_non_nullable
as int,totalDailyMissions: null == totalDailyMissions ? _self.totalDailyMissions : totalDailyMissions // ignore: cast_nullable_to_non_nullable
as int,monthlyPointsEarned: null == monthlyPointsEarned ? _self.monthlyPointsEarned : monthlyPointsEarned // ignore: cast_nullable_to_non_nullable
as int,previousMonthPoints: freezed == previousMonthPoints ? _self.previousMonthPoints : previousMonthPoints // ignore: cast_nullable_to_non_nullable
as int?,comparisonMessage: freezed == comparisonMessage ? _self.comparisonMessage : comparisonMessage // ignore: cast_nullable_to_non_nullable
as String?,recommendationMessage: freezed == recommendationMessage ? _self.recommendationMessage : recommendationMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyReport].
extension WeeklyReportPatterns on WeeklyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyReport value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyReport value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String username,  DateTime startDate,  DateTime endDate,  List<String> campaignList,  int dailyMissionCompletedCount,  int totalDailyMissions,  int monthlyPointsEarned,  int? previousMonthPoints,  String? comparisonMessage,  String? recommendationMessage,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyReport() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.startDate,_that.endDate,_that.campaignList,_that.dailyMissionCompletedCount,_that.totalDailyMissions,_that.monthlyPointsEarned,_that.previousMonthPoints,_that.comparisonMessage,_that.recommendationMessage,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String username,  DateTime startDate,  DateTime endDate,  List<String> campaignList,  int dailyMissionCompletedCount,  int totalDailyMissions,  int monthlyPointsEarned,  int? previousMonthPoints,  String? comparisonMessage,  String? recommendationMessage,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WeeklyReport():
return $default(_that.id,_that.userId,_that.username,_that.startDate,_that.endDate,_that.campaignList,_that.dailyMissionCompletedCount,_that.totalDailyMissions,_that.monthlyPointsEarned,_that.previousMonthPoints,_that.comparisonMessage,_that.recommendationMessage,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String username,  DateTime startDate,  DateTime endDate,  List<String> campaignList,  int dailyMissionCompletedCount,  int totalDailyMissions,  int monthlyPointsEarned,  int? previousMonthPoints,  String? comparisonMessage,  String? recommendationMessage,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyReport() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.startDate,_that.endDate,_that.campaignList,_that.dailyMissionCompletedCount,_that.totalDailyMissions,_that.monthlyPointsEarned,_that.previousMonthPoints,_that.comparisonMessage,_that.recommendationMessage,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyReport extends WeeklyReport {
  const _WeeklyReport({required this.id, required this.userId, required this.username, required this.startDate, required this.endDate, required final  List<String> campaignList, required this.dailyMissionCompletedCount, required this.totalDailyMissions, required this.monthlyPointsEarned, this.previousMonthPoints, this.comparisonMessage, this.recommendationMessage, required this.createdAt}): _campaignList = campaignList,super._();
  factory _WeeklyReport.fromJson(Map<String, dynamic> json) => _$WeeklyReportFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String username;
@override final  DateTime startDate;
@override final  DateTime endDate;
 final  List<String> _campaignList;
@override List<String> get campaignList {
  if (_campaignList is EqualUnmodifiableListView) return _campaignList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_campaignList);
}

// 신청한 캠페인 목록
@override final  int dailyMissionCompletedCount;
@override final  int totalDailyMissions;
@override final  int monthlyPointsEarned;
// 월간 획득 포인트
@override final  int? previousMonthPoints;
// 저번달 포인트
@override final  String? comparisonMessage;
@override final  String? recommendationMessage;
@override final  DateTime createdAt;

/// Create a copy of WeeklyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyReportCopyWith<_WeeklyReport> get copyWith => __$WeeklyReportCopyWithImpl<_WeeklyReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyReport&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._campaignList, _campaignList)&&(identical(other.dailyMissionCompletedCount, dailyMissionCompletedCount) || other.dailyMissionCompletedCount == dailyMissionCompletedCount)&&(identical(other.totalDailyMissions, totalDailyMissions) || other.totalDailyMissions == totalDailyMissions)&&(identical(other.monthlyPointsEarned, monthlyPointsEarned) || other.monthlyPointsEarned == monthlyPointsEarned)&&(identical(other.previousMonthPoints, previousMonthPoints) || other.previousMonthPoints == previousMonthPoints)&&(identical(other.comparisonMessage, comparisonMessage) || other.comparisonMessage == comparisonMessage)&&(identical(other.recommendationMessage, recommendationMessage) || other.recommendationMessage == recommendationMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,startDate,endDate,const DeepCollectionEquality().hash(_campaignList),dailyMissionCompletedCount,totalDailyMissions,monthlyPointsEarned,previousMonthPoints,comparisonMessage,recommendationMessage,createdAt);

@override
String toString() {
  return 'WeeklyReport(id: $id, userId: $userId, username: $username, startDate: $startDate, endDate: $endDate, campaignList: $campaignList, dailyMissionCompletedCount: $dailyMissionCompletedCount, totalDailyMissions: $totalDailyMissions, monthlyPointsEarned: $monthlyPointsEarned, previousMonthPoints: $previousMonthPoints, comparisonMessage: $comparisonMessage, recommendationMessage: $recommendationMessage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WeeklyReportCopyWith<$Res> implements $WeeklyReportCopyWith<$Res> {
  factory _$WeeklyReportCopyWith(_WeeklyReport value, $Res Function(_WeeklyReport) _then) = __$WeeklyReportCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String username, DateTime startDate, DateTime endDate, List<String> campaignList, int dailyMissionCompletedCount, int totalDailyMissions, int monthlyPointsEarned, int? previousMonthPoints, String? comparisonMessage, String? recommendationMessage, DateTime createdAt
});




}
/// @nodoc
class __$WeeklyReportCopyWithImpl<$Res>
    implements _$WeeklyReportCopyWith<$Res> {
  __$WeeklyReportCopyWithImpl(this._self, this._then);

  final _WeeklyReport _self;
  final $Res Function(_WeeklyReport) _then;

/// Create a copy of WeeklyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? username = null,Object? startDate = null,Object? endDate = null,Object? campaignList = null,Object? dailyMissionCompletedCount = null,Object? totalDailyMissions = null,Object? monthlyPointsEarned = null,Object? previousMonthPoints = freezed,Object? comparisonMessage = freezed,Object? recommendationMessage = freezed,Object? createdAt = null,}) {
  return _then(_WeeklyReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,campaignList: null == campaignList ? _self._campaignList : campaignList // ignore: cast_nullable_to_non_nullable
as List<String>,dailyMissionCompletedCount: null == dailyMissionCompletedCount ? _self.dailyMissionCompletedCount : dailyMissionCompletedCount // ignore: cast_nullable_to_non_nullable
as int,totalDailyMissions: null == totalDailyMissions ? _self.totalDailyMissions : totalDailyMissions // ignore: cast_nullable_to_non_nullable
as int,monthlyPointsEarned: null == monthlyPointsEarned ? _self.monthlyPointsEarned : monthlyPointsEarned // ignore: cast_nullable_to_non_nullable
as int,previousMonthPoints: freezed == previousMonthPoints ? _self.previousMonthPoints : previousMonthPoints // ignore: cast_nullable_to_non_nullable
as int?,comparisonMessage: freezed == comparisonMessage ? _self.comparisonMessage : comparisonMessage // ignore: cast_nullable_to_non_nullable
as String?,recommendationMessage: freezed == recommendationMessage ? _self.recommendationMessage : recommendationMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
