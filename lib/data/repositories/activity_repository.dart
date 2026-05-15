import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@injectable
class ActivityRepository {
  final SharedPrefHelper spHelper;

  const ActivityRepository({required this.spHelper});
}
