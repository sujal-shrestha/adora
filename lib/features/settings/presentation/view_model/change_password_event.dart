part of 'change_password_view_model.dart';

abstract class ChangePasswordEvent {}

class ChangePasswordRequested extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequested(this.currentPassword, this.newPassword);
}
