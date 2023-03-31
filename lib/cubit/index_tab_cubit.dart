import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/helpers/enums/tab_index_enum.dart';

class IndexTabCubit extends Cubit<int> {
  IndexTabCubit() : super(0);

  void setIndexByEnum(TabIndexEnum tabIndexEnum) {
    switch (tabIndexEnum) {
      case TabIndexEnum.Home:
        emit(0);
        break;
      case TabIndexEnum.Search:
        emit(1);
        break;
      case TabIndexEnum.Profile:
        emit(2);
        break;
    }
  }

  void setIndex(int index) {
    emit(index);
  }
}
