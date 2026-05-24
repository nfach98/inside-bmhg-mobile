// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../data/repositories/activity_repository.dart' as _i29;
import '../data/repositories/auth_repository.dart' as _i578;
import '../ui/attendance/bloc/attendance_bloc.dart' as _i535;
import '../ui/home/bloc/home_bloc.dart' as _i401;
import '../ui/login/bloc/login_bloc.dart' as _i919;
import '../ui/splash/bloc/splash_bloc.dart' as _i1062;
import '../utils/shared_pref_helper.dart' as _i259;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i535.AttendanceBloc>(() => _i535.AttendanceBloc());
    gh.factory<_i401.HomeBloc>(() => _i401.HomeBloc());
    gh.singleton<_i259.SharedPrefHelper>(
      () => _i259.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i259.SharedPrefHelper>()),
    );
    gh.factory<_i578.AuthRepository>(
      () => _i578.AuthRepository(
        dio: gh<_i361.Dio>(),
        spHelper: gh<_i259.SharedPrefHelper>(),
      ),
    );
    gh.factory<_i919.LoginBloc>(
      () => _i919.LoginBloc(gh<_i578.AuthRepository>()),
    );
    gh.factory<_i1062.SplashBloc>(
      () => _i1062.SplashBloc(gh<_i578.AuthRepository>()),
    );
    gh.factory<_i29.ActivityRepository>(
      () => _i29.ActivityRepository(
        spHelper: gh<_i259.SharedPrefHelper>(),
        dio: gh<_i361.Dio>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
