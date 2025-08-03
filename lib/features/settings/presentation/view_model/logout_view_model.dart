// logout_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/logout_usecase.dart';

// Events
abstract class LogoutEvent {}

class LogoutRequested extends LogoutEvent {}

// States
abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutFailure extends LogoutState {
  final String error;
  LogoutFailure(this.error);
}

// Bloc / ViewModel
class LogoutViewModel extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutViewModel(this.logoutUseCase) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());
    try {
      await logoutUseCase();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
