import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';
import 'record_detail/record_detail.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

  //==========================================//

  RecordDetailState get recordDetailState => ref.watch(recordDetailProvider);

  RecordDetail get recordDetailNotifier => ref.read(recordDetailProvider.notifier);

  //==========================================//
}
