import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@injectable
class AuthRepository {
  final SharedPrefHelper spHelper;

  const AuthRepository({required this.spHelper});
}
