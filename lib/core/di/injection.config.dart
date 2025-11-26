// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:frontend/data/data_source/agent/agent_chat.api.dart' as _i65;
import 'package:frontend/data/data_source/campaign/campaign_api.dart' as _i499;
import 'package:frontend/data/data_source/data_source_module.dart' as _i720;
import 'package:frontend/data/data_source/leaderboard/leaderboard_remote_data_source.dart'
    as _i562;
import 'package:frontend/data/data_source/mission/mission_api.dart' as _i800;
import 'package:frontend/data/data_source/recruiting/recruiting_api.dart'
    as _i324;
import 'package:frontend/data/data_source/report/report_api.dart' as _i889;
import 'package:frontend/data/data_source/storage_service.dart' as _i182;
import 'package:frontend/data/data_source/user/user_remote_data_source.dart'
    as _i64;
import 'package:frontend/data/repository_impl/agent_chat_repository_impl.dart'
    as _i315;
import 'package:frontend/data/repository_impl/campaign_repository_impl.dart'
    as _i507;
import 'package:frontend/data/repository_impl/leaderboard_repository_impl.dart'
    as _i856;
import 'package:frontend/data/repository_impl/mission_repository_impl.dart'
    as _i1053;
import 'package:frontend/data/repository_impl/recruiting_repository_impl.dart'
    as _i491;
import 'package:frontend/data/repository_impl/report_repository_impl.dart'
    as _i76;
import 'package:frontend/data/repository_impl/user_repository_impl.dart'
    as _i609;
import 'package:frontend/domain/repository/agent_chat_repository.dart' as _i93;
import 'package:frontend/domain/repository/campaign_repository.dart' as _i737;
import 'package:frontend/domain/repository/leaderboard_repository.dart'
    as _i362;
import 'package:frontend/domain/repository/mission_repository.dart' as _i629;
import 'package:frontend/domain/repository/recruiting_repository.dart' as _i138;
import 'package:frontend/domain/repository/report_repository.dart' as _i589;
import 'package:frontend/domain/repository/user_repository.dart' as _i653;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i182.StorageService>(() => _i182.StorageService());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio);
    gh.factory<_i65.AgentChatApi>(() => _i65.AgentChatApi(gh<_i361.Dio>()));
    gh.factory<_i499.CampaignApi>(() => _i499.CampaignApi(gh<_i361.Dio>()));
    gh.factory<_i562.LeaderboardRemoteDataSource>(
      () => _i562.LeaderboardRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i800.MissionApi>(() => _i800.MissionApi(gh<_i361.Dio>()));
    gh.factory<_i324.RecruitingApi>(() => _i324.RecruitingApi(gh<_i361.Dio>()));
    gh.factory<_i889.ReportApi>(() => _i889.ReportApi(gh<_i361.Dio>()));
    gh.factory<_i64.UserRemoteDataSource>(
      () => _i64.UserRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i589.ReportRepository>(
      () => _i76.ReportRepositoryImpl(gh<_i889.ReportApi>()),
    );
    gh.factory<_i93.AgentChatRepository>(
      () => _i315.AgentChatRepositoryImpl(gh<_i65.AgentChatApi>()),
    );
    gh.factory<_i362.LeaderboardRepository>(
      () => _i856.LeaderboardRepositoryImpl(
        gh<_i562.LeaderboardRemoteDataSource>(),
      ),
    );
    gh.factory<_i138.RecruitingRepository>(
      () => _i491.RecruitingRepositoryImpl(gh<_i324.RecruitingApi>()),
    );
    gh.factory<_i629.MissionRepository>(
      () => _i1053.MissionRepositoryImpl(
        gh<_i800.MissionApi>(),
        gh<_i499.CampaignApi>(),
      ),
    );
    gh.factory<_i737.CampaignRepository>(
      () => _i507.CampaignRepositoryImpl(gh<_i499.CampaignApi>()),
    );
    gh.factory<_i653.UserRepository>(
      () => _i609.UserRepositoryImpl(gh<_i64.UserRemoteDataSource>()),
    );
    return this;
  }
}

class _$DioModule extends _i720.DioModule {}
