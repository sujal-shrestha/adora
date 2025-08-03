import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/change_password_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordViewModel extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordViewModel({required this.changePasswordUseCase}) : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onChangePasswordRequested(
      ChangePasswordRequested event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordLoading());
    try {
      await changePasswordUseCase(event.currentPassword, event.newPassword);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}
