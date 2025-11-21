// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyReport {

 ReportUser get user; ReportPeriod get period; ReportCampaigns get campaigns; ReportMissions get missions; ReportPoints get points; ReportTmi get tmi; ReportReward get reward;
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<MonthlyReport> get copyWith => _$MonthlyReportCopyWithImpl<MonthlyReport>(this as MonthlyReport, _$identity);

  /// Serializes this MonthlyReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReport&&(identical(other.user, user) || other.user == user)&&(identical(other.period, period) || other.period == period)&&(identical(other.campaigns, campaigns) || other.campaigns == campaigns)&&(identical(other.missions, missions) || other.missions == missions)&&(identical(other.points, points) || other.points == points)&&(identical(other.tmi, tmi) || other.tmi == tmi)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,period,campaigns,missions,points,tmi,reward);

@override
String toString() {
  return 'MonthlyReport(user: $user, period: $period, campaigns: $campaigns, missions: $missions, points: $points, tmi: $tmi, reward: $reward)';
}


}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>  {
  factory $MonthlyReportCopyWith(MonthlyReport value, $Res Function(MonthlyReport) _then) = _$MonthlyReportCopyWithImpl;
@useResult
$Res call({
 ReportUser user, ReportPeriod period, ReportCampaigns campaigns, ReportMissions missions, ReportPoints points, ReportTmi tmi, ReportReward reward
});


$ReportUserCopyWith<$Res> get user;$ReportPeriodCopyWith<$Res> get period;$ReportCampaignsCopyWith<$Res> get campaigns;$ReportMissionsCopyWith<$Res> get missions;$ReportPointsCopyWith<$Res> get points;$ReportTmiCopyWith<$Res> get tmi;$ReportRewardCopyWith<$Res> get reward;

}
/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? period = null,Object? campaigns = null,Object? missions = null,Object? points = null,Object? tmi = null,Object? reward = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ReportUser,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ReportPeriod,campaigns: null == campaigns ? _self.campaigns : campaigns // ignore: cast_nullable_to_non_nullable
as ReportCampaigns,missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as ReportMissions,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as ReportPoints,tmi: null == tmi ? _self.tmi : tmi // ignore: cast_nullable_to_non_nullable
as ReportTmi,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as ReportReward,
  ));
}
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportUserCopyWith<$Res> get user {
  
  return $ReportUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<$Res> get period {
  
  return $ReportPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCampaignsCopyWith<$Res> get campaigns {
  
  return $ReportCampaignsCopyWith<$Res>(_self.campaigns, (value) {
    return _then(_self.copyWith(campaigns: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportMissionsCopyWith<$Res> get missions {
  
  return $ReportMissionsCopyWith<$Res>(_self.missions, (value) {
    return _then(_self.copyWith(missions: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPointsCopyWith<$Res> get points {
  
  return $ReportPointsCopyWith<$Res>(_self.points, (value) {
    return _then(_self.copyWith(points: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTmiCopyWith<$Res> get tmi {
  
  return $ReportTmiCopyWith<$Res>(_self.tmi, (value) {
    return _then(_self.copyWith(tmi: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportRewardCopyWith<$Res> get reward {
  
  return $ReportRewardCopyWith<$Res>(_self.reward, (value) {
    return _then(_self.copyWith(reward: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyReport].
extension MonthlyReportPatterns on MonthlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReport value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportUser user,  ReportPeriod period,  ReportCampaigns campaigns,  ReportMissions missions,  ReportPoints points,  ReportTmi tmi,  ReportReward reward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.user,_that.period,_that.campaigns,_that.missions,_that.points,_that.tmi,_that.reward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportUser user,  ReportPeriod period,  ReportCampaigns campaigns,  ReportMissions missions,  ReportPoints points,  ReportTmi tmi,  ReportReward reward)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport():
return $default(_that.user,_that.period,_that.campaigns,_that.missions,_that.points,_that.tmi,_that.reward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportUser user,  ReportPeriod period,  ReportCampaigns campaigns,  ReportMissions missions,  ReportPoints points,  ReportTmi tmi,  ReportReward reward)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.user,_that.period,_that.campaigns,_that.missions,_that.points,_that.tmi,_that.reward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyReport implements MonthlyReport {
  const _MonthlyReport({required this.user, required this.period, required this.campaigns, required this.missions, required this.points, required this.tmi, required this.reward});
  factory _MonthlyReport.fromJson(Map<String, dynamic> json) => _$MonthlyReportFromJson(json);

@override final  ReportUser user;
@override final  ReportPeriod period;
@override final  ReportCampaigns campaigns;
@override final  ReportMissions missions;
@override final  ReportPoints points;
@override final  ReportTmi tmi;
@override final  ReportReward reward;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportCopyWith<_MonthlyReport> get copyWith => __$MonthlyReportCopyWithImpl<_MonthlyReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReport&&(identical(other.user, user) || other.user == user)&&(identical(other.period, period) || other.period == period)&&(identical(other.campaigns, campaigns) || other.campaigns == campaigns)&&(identical(other.missions, missions) || other.missions == missions)&&(identical(other.points, points) || other.points == points)&&(identical(other.tmi, tmi) || other.tmi == tmi)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,period,campaigns,missions,points,tmi,reward);

@override
String toString() {
  return 'MonthlyReport(user: $user, period: $period, campaigns: $campaigns, missions: $missions, points: $points, tmi: $tmi, reward: $reward)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportCopyWith<$Res> implements $MonthlyReportCopyWith<$Res> {
  factory _$MonthlyReportCopyWith(_MonthlyReport value, $Res Function(_MonthlyReport) _then) = __$MonthlyReportCopyWithImpl;
@override @useResult
$Res call({
 ReportUser user, ReportPeriod period, ReportCampaigns campaigns, ReportMissions missions, ReportPoints points, ReportTmi tmi, ReportReward reward
});


@override $ReportUserCopyWith<$Res> get user;@override $ReportPeriodCopyWith<$Res> get period;@override $ReportCampaignsCopyWith<$Res> get campaigns;@override $ReportMissionsCopyWith<$Res> get missions;@override $ReportPointsCopyWith<$Res> get points;@override $ReportTmiCopyWith<$Res> get tmi;@override $ReportRewardCopyWith<$Res> get reward;

}
/// @nodoc
class __$MonthlyReportCopyWithImpl<$Res>
    implements _$MonthlyReportCopyWith<$Res> {
  __$MonthlyReportCopyWithImpl(this._self, this._then);

  final _MonthlyReport _self;
  final $Res Function(_MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? period = null,Object? campaigns = null,Object? missions = null,Object? points = null,Object? tmi = null,Object? reward = null,}) {
  return _then(_MonthlyReport(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ReportUser,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ReportPeriod,campaigns: null == campaigns ? _self.campaigns : campaigns // ignore: cast_nullable_to_non_nullable
as ReportCampaigns,missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as ReportMissions,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as ReportPoints,tmi: null == tmi ? _self.tmi : tmi // ignore: cast_nullable_to_non_nullable
as ReportTmi,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as ReportReward,
  ));
}

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportUserCopyWith<$Res> get user {
  
  return $ReportUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<$Res> get period {
  
  return $ReportPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCampaignsCopyWith<$Res> get campaigns {
  
  return $ReportCampaignsCopyWith<$Res>(_self.campaigns, (value) {
    return _then(_self.copyWith(campaigns: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportMissionsCopyWith<$Res> get missions {
  
  return $ReportMissionsCopyWith<$Res>(_self.missions, (value) {
    return _then(_self.copyWith(missions: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPointsCopyWith<$Res> get points {
  
  return $ReportPointsCopyWith<$Res>(_self.points, (value) {
    return _then(_self.copyWith(points: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTmiCopyWith<$Res> get tmi {
  
  return $ReportTmiCopyWith<$Res>(_self.tmi, (value) {
    return _then(_self.copyWith(tmi: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportRewardCopyWith<$Res> get reward {
  
  return $ReportRewardCopyWith<$Res>(_self.reward, (value) {
    return _then(_self.copyWith(reward: value));
  });
}
}


/// @nodoc
mixin _$ReportUser {

 String get id; String get username;
/// Create a copy of ReportUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportUserCopyWith<ReportUser> get copyWith => _$ReportUserCopyWithImpl<ReportUser>(this as ReportUser, _$identity);

  /// Serializes this ReportUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username);

@override
String toString() {
  return 'ReportUser(id: $id, username: $username)';
}


}

/// @nodoc
abstract mixin class $ReportUserCopyWith<$Res>  {
  factory $ReportUserCopyWith(ReportUser value, $Res Function(ReportUser) _then) = _$ReportUserCopyWithImpl;
@useResult
$Res call({
 String id, String username
});




}
/// @nodoc
class _$ReportUserCopyWithImpl<$Res>
    implements $ReportUserCopyWith<$Res> {
  _$ReportUserCopyWithImpl(this._self, this._then);

  final ReportUser _self;
  final $Res Function(ReportUser) _then;

/// Create a copy of ReportUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportUser].
extension ReportUserPatterns on ReportUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportUser value)  $default,){
final _that = this;
switch (_that) {
case _ReportUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportUser value)?  $default,){
final _that = this;
switch (_that) {
case _ReportUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportUser() when $default != null:
return $default(_that.id,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username)  $default,) {final _that = this;
switch (_that) {
case _ReportUser():
return $default(_that.id,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username)?  $default,) {final _that = this;
switch (_that) {
case _ReportUser() when $default != null:
return $default(_that.id,_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportUser implements ReportUser {
  const _ReportUser({required this.id, required this.username});
  factory _ReportUser.fromJson(Map<String, dynamic> json) => _$ReportUserFromJson(json);

@override final  String id;
@override final  String username;

/// Create a copy of ReportUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportUserCopyWith<_ReportUser> get copyWith => __$ReportUserCopyWithImpl<_ReportUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username);

@override
String toString() {
  return 'ReportUser(id: $id, username: $username)';
}


}

/// @nodoc
abstract mixin class _$ReportUserCopyWith<$Res> implements $ReportUserCopyWith<$Res> {
  factory _$ReportUserCopyWith(_ReportUser value, $Res Function(_ReportUser) _then) = __$ReportUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String username
});




}
/// @nodoc
class __$ReportUserCopyWithImpl<$Res>
    implements _$ReportUserCopyWith<$Res> {
  __$ReportUserCopyWithImpl(this._self, this._then);

  final _ReportUser _self;
  final $Res Function(_ReportUser) _then;

/// Create a copy of ReportUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,}) {
  return _then(_ReportUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReportPeriod {

 String get startDate; String get endDate;
/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<ReportPeriod> get copyWith => _$ReportPeriodCopyWithImpl<ReportPeriod>(this as ReportPeriod, _$identity);

  /// Serializes this ReportPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'ReportPeriod(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $ReportPeriodCopyWith<$Res>  {
  factory $ReportPeriodCopyWith(ReportPeriod value, $Res Function(ReportPeriod) _then) = _$ReportPeriodCopyWithImpl;
@useResult
$Res call({
 String startDate, String endDate
});




}
/// @nodoc
class _$ReportPeriodCopyWithImpl<$Res>
    implements $ReportPeriodCopyWith<$Res> {
  _$ReportPeriodCopyWithImpl(this._self, this._then);

  final ReportPeriod _self;
  final $Res Function(ReportPeriod) _then;

/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPeriod].
extension ReportPeriodPatterns on ReportPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPeriod value)  $default,){
final _that = this;
switch (_that) {
case _ReportPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String startDate,  String endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
return $default(_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String startDate,  String endDate)  $default,) {final _that = this;
switch (_that) {
case _ReportPeriod():
return $default(_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String startDate,  String endDate)?  $default,) {final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
return $default(_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPeriod implements ReportPeriod {
  const _ReportPeriod({required this.startDate, required this.endDate});
  factory _ReportPeriod.fromJson(Map<String, dynamic> json) => _$ReportPeriodFromJson(json);

@override final  String startDate;
@override final  String endDate;

/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPeriodCopyWith<_ReportPeriod> get copyWith => __$ReportPeriodCopyWithImpl<_ReportPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'ReportPeriod(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$ReportPeriodCopyWith<$Res> implements $ReportPeriodCopyWith<$Res> {
  factory _$ReportPeriodCopyWith(_ReportPeriod value, $Res Function(_ReportPeriod) _then) = __$ReportPeriodCopyWithImpl;
@override @useResult
$Res call({
 String startDate, String endDate
});




}
/// @nodoc
class __$ReportPeriodCopyWithImpl<$Res>
    implements _$ReportPeriodCopyWith<$Res> {
  __$ReportPeriodCopyWithImpl(this._self, this._then);

  final _ReportPeriod _self;
  final $Res Function(_ReportPeriod) _then;

/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(_ReportPeriod(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReportCampaigns {

 List<CampaignItem> get list; int get count;
/// Create a copy of ReportCampaigns
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCampaignsCopyWith<ReportCampaigns> get copyWith => _$ReportCampaignsCopyWithImpl<ReportCampaigns>(this as ReportCampaigns, _$identity);

  /// Serializes this ReportCampaigns to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCampaigns&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),count);

@override
String toString() {
  return 'ReportCampaigns(list: $list, count: $count)';
}


}

/// @nodoc
abstract mixin class $ReportCampaignsCopyWith<$Res>  {
  factory $ReportCampaignsCopyWith(ReportCampaigns value, $Res Function(ReportCampaigns) _then) = _$ReportCampaignsCopyWithImpl;
@useResult
$Res call({
 List<CampaignItem> list, int count
});




}
/// @nodoc
class _$ReportCampaignsCopyWithImpl<$Res>
    implements $ReportCampaignsCopyWith<$Res> {
  _$ReportCampaignsCopyWithImpl(this._self, this._then);

  final ReportCampaigns _self;
  final $Res Function(ReportCampaigns) _then;

/// Create a copy of ReportCampaigns
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? count = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<CampaignItem>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportCampaigns].
extension ReportCampaignsPatterns on ReportCampaigns {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportCampaigns value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportCampaigns() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportCampaigns value)  $default,){
final _that = this;
switch (_that) {
case _ReportCampaigns():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportCampaigns value)?  $default,){
final _that = this;
switch (_that) {
case _ReportCampaigns() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CampaignItem> list,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportCampaigns() when $default != null:
return $default(_that.list,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CampaignItem> list,  int count)  $default,) {final _that = this;
switch (_that) {
case _ReportCampaigns():
return $default(_that.list,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CampaignItem> list,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ReportCampaigns() when $default != null:
return $default(_that.list,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportCampaigns implements ReportCampaigns {
  const _ReportCampaigns({required final  List<CampaignItem> list, required this.count}): _list = list;
  factory _ReportCampaigns.fromJson(Map<String, dynamic> json) => _$ReportCampaignsFromJson(json);

 final  List<CampaignItem> _list;
@override List<CampaignItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override final  int count;

/// Create a copy of ReportCampaigns
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCampaignsCopyWith<_ReportCampaigns> get copyWith => __$ReportCampaignsCopyWithImpl<_ReportCampaigns>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportCampaignsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportCampaigns&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),count);

@override
String toString() {
  return 'ReportCampaigns(list: $list, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ReportCampaignsCopyWith<$Res> implements $ReportCampaignsCopyWith<$Res> {
  factory _$ReportCampaignsCopyWith(_ReportCampaigns value, $Res Function(_ReportCampaigns) _then) = __$ReportCampaignsCopyWithImpl;
@override @useResult
$Res call({
 List<CampaignItem> list, int count
});




}
/// @nodoc
class __$ReportCampaignsCopyWithImpl<$Res>
    implements _$ReportCampaignsCopyWith<$Res> {
  __$ReportCampaignsCopyWithImpl(this._self, this._then);

  final _ReportCampaigns _self;
  final $Res Function(_ReportCampaigns) _then;

/// Create a copy of ReportCampaigns
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? count = null,}) {
  return _then(_ReportCampaigns(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<CampaignItem>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CampaignItem {

 int get id; String get title; String get description;
/// Create a copy of CampaignItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignItemCopyWith<CampaignItem> get copyWith => _$CampaignItemCopyWithImpl<CampaignItem>(this as CampaignItem, _$identity);

  /// Serializes this CampaignItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description);

@override
String toString() {
  return 'CampaignItem(id: $id, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $CampaignItemCopyWith<$Res>  {
  factory $CampaignItemCopyWith(CampaignItem value, $Res Function(CampaignItem) _then) = _$CampaignItemCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description
});




}
/// @nodoc
class _$CampaignItemCopyWithImpl<$Res>
    implements $CampaignItemCopyWith<$Res> {
  _$CampaignItemCopyWithImpl(this._self, this._then);

  final CampaignItem _self;
  final $Res Function(CampaignItem) _then;

/// Create a copy of CampaignItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CampaignItem].
extension CampaignItemPatterns on CampaignItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampaignItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampaignItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampaignItem value)  $default,){
final _that = this;
switch (_that) {
case _CampaignItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampaignItem value)?  $default,){
final _that = this;
switch (_that) {
case _CampaignItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampaignItem() when $default != null:
return $default(_that.id,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description)  $default,) {final _that = this;
switch (_that) {
case _CampaignItem():
return $default(_that.id,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description)?  $default,) {final _that = this;
switch (_that) {
case _CampaignItem() when $default != null:
return $default(_that.id,_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampaignItem implements CampaignItem {
  const _CampaignItem({required this.id, required this.title, required this.description});
  factory _CampaignItem.fromJson(Map<String, dynamic> json) => _$CampaignItemFromJson(json);

@override final  int id;
@override final  String title;
@override final  String description;

/// Create a copy of CampaignItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampaignItemCopyWith<_CampaignItem> get copyWith => __$CampaignItemCopyWithImpl<_CampaignItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampaignItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampaignItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description);

@override
String toString() {
  return 'CampaignItem(id: $id, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CampaignItemCopyWith<$Res> implements $CampaignItemCopyWith<$Res> {
  factory _$CampaignItemCopyWith(_CampaignItem value, $Res Function(_CampaignItem) _then) = __$CampaignItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description
});




}
/// @nodoc
class __$CampaignItemCopyWithImpl<$Res>
    implements _$CampaignItemCopyWith<$Res> {
  __$CampaignItemCopyWithImpl(this._self, this._then);

  final _CampaignItem _self;
  final $Res Function(_CampaignItem) _then;

/// Create a copy of CampaignItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,}) {
  return _then(_CampaignItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReportMissions {

 List<MissionCategory> get completedByCategory; int get totalCompleted;
/// Create a copy of ReportMissions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMissionsCopyWith<ReportMissions> get copyWith => _$ReportMissionsCopyWithImpl<ReportMissions>(this as ReportMissions, _$identity);

  /// Serializes this ReportMissions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMissions&&const DeepCollectionEquality().equals(other.completedByCategory, completedByCategory)&&(identical(other.totalCompleted, totalCompleted) || other.totalCompleted == totalCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(completedByCategory),totalCompleted);

@override
String toString() {
  return 'ReportMissions(completedByCategory: $completedByCategory, totalCompleted: $totalCompleted)';
}


}

/// @nodoc
abstract mixin class $ReportMissionsCopyWith<$Res>  {
  factory $ReportMissionsCopyWith(ReportMissions value, $Res Function(ReportMissions) _then) = _$ReportMissionsCopyWithImpl;
@useResult
$Res call({
 List<MissionCategory> completedByCategory, int totalCompleted
});




}
/// @nodoc
class _$ReportMissionsCopyWithImpl<$Res>
    implements $ReportMissionsCopyWith<$Res> {
  _$ReportMissionsCopyWithImpl(this._self, this._then);

  final ReportMissions _self;
  final $Res Function(ReportMissions) _then;

/// Create a copy of ReportMissions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedByCategory = null,Object? totalCompleted = null,}) {
  return _then(_self.copyWith(
completedByCategory: null == completedByCategory ? _self.completedByCategory : completedByCategory // ignore: cast_nullable_to_non_nullable
as List<MissionCategory>,totalCompleted: null == totalCompleted ? _self.totalCompleted : totalCompleted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportMissions].
extension ReportMissionsPatterns on ReportMissions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMissions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMissions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMissions value)  $default,){
final _that = this;
switch (_that) {
case _ReportMissions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMissions value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMissions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MissionCategory> completedByCategory,  int totalCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMissions() when $default != null:
return $default(_that.completedByCategory,_that.totalCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MissionCategory> completedByCategory,  int totalCompleted)  $default,) {final _that = this;
switch (_that) {
case _ReportMissions():
return $default(_that.completedByCategory,_that.totalCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MissionCategory> completedByCategory,  int totalCompleted)?  $default,) {final _that = this;
switch (_that) {
case _ReportMissions() when $default != null:
return $default(_that.completedByCategory,_that.totalCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMissions implements ReportMissions {
  const _ReportMissions({required final  List<MissionCategory> completedByCategory, required this.totalCompleted}): _completedByCategory = completedByCategory;
  factory _ReportMissions.fromJson(Map<String, dynamic> json) => _$ReportMissionsFromJson(json);

 final  List<MissionCategory> _completedByCategory;
@override List<MissionCategory> get completedByCategory {
  if (_completedByCategory is EqualUnmodifiableListView) return _completedByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedByCategory);
}

@override final  int totalCompleted;

/// Create a copy of ReportMissions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMissionsCopyWith<_ReportMissions> get copyWith => __$ReportMissionsCopyWithImpl<_ReportMissions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMissionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMissions&&const DeepCollectionEquality().equals(other._completedByCategory, _completedByCategory)&&(identical(other.totalCompleted, totalCompleted) || other.totalCompleted == totalCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_completedByCategory),totalCompleted);

@override
String toString() {
  return 'ReportMissions(completedByCategory: $completedByCategory, totalCompleted: $totalCompleted)';
}


}

/// @nodoc
abstract mixin class _$ReportMissionsCopyWith<$Res> implements $ReportMissionsCopyWith<$Res> {
  factory _$ReportMissionsCopyWith(_ReportMissions value, $Res Function(_ReportMissions) _then) = __$ReportMissionsCopyWithImpl;
@override @useResult
$Res call({
 List<MissionCategory> completedByCategory, int totalCompleted
});




}
/// @nodoc
class __$ReportMissionsCopyWithImpl<$Res>
    implements _$ReportMissionsCopyWith<$Res> {
  __$ReportMissionsCopyWithImpl(this._self, this._then);

  final _ReportMissions _self;
  final $Res Function(_ReportMissions) _then;

/// Create a copy of ReportMissions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedByCategory = null,Object? totalCompleted = null,}) {
  return _then(_ReportMissions(
completedByCategory: null == completedByCategory ? _self._completedByCategory : completedByCategory // ignore: cast_nullable_to_non_nullable
as List<MissionCategory>,totalCompleted: null == totalCompleted ? _self.totalCompleted : totalCompleted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MissionCategory {

 String get category; int get count;
/// Create a copy of MissionCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionCategoryCopyWith<MissionCategory> get copyWith => _$MissionCategoryCopyWithImpl<MissionCategory>(this as MissionCategory, _$identity);

  /// Serializes this MissionCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionCategory&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,count);

@override
String toString() {
  return 'MissionCategory(category: $category, count: $count)';
}


}

/// @nodoc
abstract mixin class $MissionCategoryCopyWith<$Res>  {
  factory $MissionCategoryCopyWith(MissionCategory value, $Res Function(MissionCategory) _then) = _$MissionCategoryCopyWithImpl;
@useResult
$Res call({
 String category, int count
});




}
/// @nodoc
class _$MissionCategoryCopyWithImpl<$Res>
    implements $MissionCategoryCopyWith<$Res> {
  _$MissionCategoryCopyWithImpl(this._self, this._then);

  final MissionCategory _self;
  final $Res Function(MissionCategory) _then;

/// Create a copy of MissionCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? count = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionCategory].
extension MissionCategoryPatterns on MissionCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionCategory value)  $default,){
final _that = this;
switch (_that) {
case _MissionCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionCategory value)?  $default,){
final _that = this;
switch (_that) {
case _MissionCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionCategory() when $default != null:
return $default(_that.category,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  int count)  $default,) {final _that = this;
switch (_that) {
case _MissionCategory():
return $default(_that.category,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  int count)?  $default,) {final _that = this;
switch (_that) {
case _MissionCategory() when $default != null:
return $default(_that.category,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MissionCategory implements MissionCategory {
  const _MissionCategory({required this.category, required this.count});
  factory _MissionCategory.fromJson(Map<String, dynamic> json) => _$MissionCategoryFromJson(json);

@override final  String category;
@override final  int count;

/// Create a copy of MissionCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionCategoryCopyWith<_MissionCategory> get copyWith => __$MissionCategoryCopyWithImpl<_MissionCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionCategory&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,count);

@override
String toString() {
  return 'MissionCategory(category: $category, count: $count)';
}


}

/// @nodoc
abstract mixin class _$MissionCategoryCopyWith<$Res> implements $MissionCategoryCopyWith<$Res> {
  factory _$MissionCategoryCopyWith(_MissionCategory value, $Res Function(_MissionCategory) _then) = __$MissionCategoryCopyWithImpl;
@override @useResult
$Res call({
 String category, int count
});




}
/// @nodoc
class __$MissionCategoryCopyWithImpl<$Res>
    implements _$MissionCategoryCopyWith<$Res> {
  __$MissionCategoryCopyWithImpl(this._self, this._then);

  final _MissionCategory _self;
  final $Res Function(_MissionCategory) _then;

/// Create a copy of MissionCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? count = null,}) {
  return _then(_MissionCategory(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReportPoints {

 int get currentMonth; int get previousMonth; int get difference;
/// Create a copy of ReportPoints
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPointsCopyWith<ReportPoints> get copyWith => _$ReportPointsCopyWithImpl<ReportPoints>(this as ReportPoints, _$identity);

  /// Serializes this ReportPoints to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPoints&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&(identical(other.previousMonth, previousMonth) || other.previousMonth == previousMonth)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentMonth,previousMonth,difference);

@override
String toString() {
  return 'ReportPoints(currentMonth: $currentMonth, previousMonth: $previousMonth, difference: $difference)';
}


}

/// @nodoc
abstract mixin class $ReportPointsCopyWith<$Res>  {
  factory $ReportPointsCopyWith(ReportPoints value, $Res Function(ReportPoints) _then) = _$ReportPointsCopyWithImpl;
@useResult
$Res call({
 int currentMonth, int previousMonth, int difference
});




}
/// @nodoc
class _$ReportPointsCopyWithImpl<$Res>
    implements $ReportPointsCopyWith<$Res> {
  _$ReportPointsCopyWithImpl(this._self, this._then);

  final ReportPoints _self;
  final $Res Function(ReportPoints) _then;

/// Create a copy of ReportPoints
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentMonth = null,Object? previousMonth = null,Object? difference = null,}) {
  return _then(_self.copyWith(
currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as int,previousMonth: null == previousMonth ? _self.previousMonth : previousMonth // ignore: cast_nullable_to_non_nullable
as int,difference: null == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPoints].
extension ReportPointsPatterns on ReportPoints {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPoints value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPoints() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPoints value)  $default,){
final _that = this;
switch (_that) {
case _ReportPoints():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPoints value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPoints() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentMonth,  int previousMonth,  int difference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPoints() when $default != null:
return $default(_that.currentMonth,_that.previousMonth,_that.difference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentMonth,  int previousMonth,  int difference)  $default,) {final _that = this;
switch (_that) {
case _ReportPoints():
return $default(_that.currentMonth,_that.previousMonth,_that.difference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentMonth,  int previousMonth,  int difference)?  $default,) {final _that = this;
switch (_that) {
case _ReportPoints() when $default != null:
return $default(_that.currentMonth,_that.previousMonth,_that.difference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPoints implements ReportPoints {
  const _ReportPoints({required this.currentMonth, required this.previousMonth, required this.difference});
  factory _ReportPoints.fromJson(Map<String, dynamic> json) => _$ReportPointsFromJson(json);

@override final  int currentMonth;
@override final  int previousMonth;
@override final  int difference;

/// Create a copy of ReportPoints
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPointsCopyWith<_ReportPoints> get copyWith => __$ReportPointsCopyWithImpl<_ReportPoints>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPointsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPoints&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&(identical(other.previousMonth, previousMonth) || other.previousMonth == previousMonth)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentMonth,previousMonth,difference);

@override
String toString() {
  return 'ReportPoints(currentMonth: $currentMonth, previousMonth: $previousMonth, difference: $difference)';
}


}

/// @nodoc
abstract mixin class _$ReportPointsCopyWith<$Res> implements $ReportPointsCopyWith<$Res> {
  factory _$ReportPointsCopyWith(_ReportPoints value, $Res Function(_ReportPoints) _then) = __$ReportPointsCopyWithImpl;
@override @useResult
$Res call({
 int currentMonth, int previousMonth, int difference
});




}
/// @nodoc
class __$ReportPointsCopyWithImpl<$Res>
    implements _$ReportPointsCopyWith<$Res> {
  __$ReportPointsCopyWithImpl(this._self, this._then);

  final _ReportPoints _self;
  final $Res Function(_ReportPoints) _then;

/// Create a copy of ReportPoints
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentMonth = null,Object? previousMonth = null,Object? difference = null,}) {
  return _then(_ReportPoints(
currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as int,previousMonth: null == previousMonth ? _self.previousMonth : previousMonth // ignore: cast_nullable_to_non_nullable
as int,difference: null == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReportTmi {

 String get content;
/// Create a copy of ReportTmi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTmiCopyWith<ReportTmi> get copyWith => _$ReportTmiCopyWithImpl<ReportTmi>(this as ReportTmi, _$identity);

  /// Serializes this ReportTmi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTmi&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'ReportTmi(content: $content)';
}


}

/// @nodoc
abstract mixin class $ReportTmiCopyWith<$Res>  {
  factory $ReportTmiCopyWith(ReportTmi value, $Res Function(ReportTmi) _then) = _$ReportTmiCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$ReportTmiCopyWithImpl<$Res>
    implements $ReportTmiCopyWith<$Res> {
  _$ReportTmiCopyWithImpl(this._self, this._then);

  final ReportTmi _self;
  final $Res Function(ReportTmi) _then;

/// Create a copy of ReportTmi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportTmi].
extension ReportTmiPatterns on ReportTmi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTmi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTmi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTmi value)  $default,){
final _that = this;
switch (_that) {
case _ReportTmi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTmi value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTmi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTmi() when $default != null:
return $default(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content)  $default,) {final _that = this;
switch (_that) {
case _ReportTmi():
return $default(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content)?  $default,) {final _that = this;
switch (_that) {
case _ReportTmi() when $default != null:
return $default(_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTmi implements ReportTmi {
  const _ReportTmi({required this.content});
  factory _ReportTmi.fromJson(Map<String, dynamic> json) => _$ReportTmiFromJson(json);

@override final  String content;

/// Create a copy of ReportTmi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTmiCopyWith<_ReportTmi> get copyWith => __$ReportTmiCopyWithImpl<_ReportTmi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTmiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTmi&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'ReportTmi(content: $content)';
}


}

/// @nodoc
abstract mixin class _$ReportTmiCopyWith<$Res> implements $ReportTmiCopyWith<$Res> {
  factory _$ReportTmiCopyWith(_ReportTmi value, $Res Function(_ReportTmi) _then) = __$ReportTmiCopyWithImpl;
@override @useResult
$Res call({
 String content
});




}
/// @nodoc
class __$ReportTmiCopyWithImpl<$Res>
    implements _$ReportTmiCopyWith<$Res> {
  __$ReportTmiCopyWithImpl(this._self, this._then);

  final _ReportTmi _self;
  final $Res Function(_ReportTmi) _then;

/// Create a copy of ReportTmi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_ReportTmi(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReportReward {

 bool get isFirstView; int get pointsEarned;
/// Create a copy of ReportReward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportRewardCopyWith<ReportReward> get copyWith => _$ReportRewardCopyWithImpl<ReportReward>(this as ReportReward, _$identity);

  /// Serializes this ReportReward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportReward&&(identical(other.isFirstView, isFirstView) || other.isFirstView == isFirstView)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFirstView,pointsEarned);

@override
String toString() {
  return 'ReportReward(isFirstView: $isFirstView, pointsEarned: $pointsEarned)';
}


}

/// @nodoc
abstract mixin class $ReportRewardCopyWith<$Res>  {
  factory $ReportRewardCopyWith(ReportReward value, $Res Function(ReportReward) _then) = _$ReportRewardCopyWithImpl;
@useResult
$Res call({
 bool isFirstView, int pointsEarned
});




}
/// @nodoc
class _$ReportRewardCopyWithImpl<$Res>
    implements $ReportRewardCopyWith<$Res> {
  _$ReportRewardCopyWithImpl(this._self, this._then);

  final ReportReward _self;
  final $Res Function(ReportReward) _then;

/// Create a copy of ReportReward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFirstView = null,Object? pointsEarned = null,}) {
  return _then(_self.copyWith(
isFirstView: null == isFirstView ? _self.isFirstView : isFirstView // ignore: cast_nullable_to_non_nullable
as bool,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportReward].
extension ReportRewardPatterns on ReportReward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportReward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportReward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportReward value)  $default,){
final _that = this;
switch (_that) {
case _ReportReward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportReward value)?  $default,){
final _that = this;
switch (_that) {
case _ReportReward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isFirstView,  int pointsEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportReward() when $default != null:
return $default(_that.isFirstView,_that.pointsEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isFirstView,  int pointsEarned)  $default,) {final _that = this;
switch (_that) {
case _ReportReward():
return $default(_that.isFirstView,_that.pointsEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isFirstView,  int pointsEarned)?  $default,) {final _that = this;
switch (_that) {
case _ReportReward() when $default != null:
return $default(_that.isFirstView,_that.pointsEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportReward implements ReportReward {
  const _ReportReward({required this.isFirstView, required this.pointsEarned});
  factory _ReportReward.fromJson(Map<String, dynamic> json) => _$ReportRewardFromJson(json);

@override final  bool isFirstView;
@override final  int pointsEarned;

/// Create a copy of ReportReward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportRewardCopyWith<_ReportReward> get copyWith => __$ReportRewardCopyWithImpl<_ReportReward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportRewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportReward&&(identical(other.isFirstView, isFirstView) || other.isFirstView == isFirstView)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFirstView,pointsEarned);

@override
String toString() {
  return 'ReportReward(isFirstView: $isFirstView, pointsEarned: $pointsEarned)';
}


}

/// @nodoc
abstract mixin class _$ReportRewardCopyWith<$Res> implements $ReportRewardCopyWith<$Res> {
  factory _$ReportRewardCopyWith(_ReportReward value, $Res Function(_ReportReward) _then) = __$ReportRewardCopyWithImpl;
@override @useResult
$Res call({
 bool isFirstView, int pointsEarned
});




}
/// @nodoc
class __$ReportRewardCopyWithImpl<$Res>
    implements _$ReportRewardCopyWith<$Res> {
  __$ReportRewardCopyWithImpl(this._self, this._then);

  final _ReportReward _self;
  final $Res Function(_ReportReward) _then;

/// Create a copy of ReportReward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFirstView = null,Object? pointsEarned = null,}) {
  return _then(_ReportReward(
isFirstView: null == isFirstView ? _self.isFirstView : isFirstView // ignore: cast_nullable_to_non_nullable
as bool,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
