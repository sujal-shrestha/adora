// delete_account_view_model.dart
import 'package:adora_mobile_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class DeleteAccountEvent {}

class DeleteAccountRequested extends DeleteAccountEvent {}

// STATES
abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class DeleteAccountFailure extends DeleteAccountState {
  final String error;
  DeleteAccountFailure(this.error);
}

// BLOC / VIEWMODEL
class DeleteAccountViewModel extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountViewModel(this.deleteAccountUseCase) : super(DeleteAccountInitial()) {
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoading());
    try {
      await deleteAccountUseCase();
      emit(DeleteAccountSuccess());
    } catch (e) {
      emit(DeleteAccountFailure(e.toString()));
    }
  }
}
