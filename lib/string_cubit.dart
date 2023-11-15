import 'package:bloc/bloc.dart';

class IntCubit extends Cubit<int> {
  IntCubit() : super(0);

  void addData() {
    emit(state + 1);
  }

  void removeData() {
    if (state > 0) {
      emit(state - 1);
    }
  }
}
