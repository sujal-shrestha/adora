// lib/features/ads/presentation/bloc/generate_ad_state.dart

part of 'generate_ad_bloc.dart';

abstract class GenerateAdState {}

class GenerateAdInitial extends GenerateAdState {}
class GenerateAdLoading extends GenerateAdState {}
class GenerateAdSuccess extends GenerateAdState {
  final String imageUrl;
  final int remainingCredits;
  GenerateAdSuccess(this.imageUrl, this.remainingCredits);
}
class GenerateAdFailure extends GenerateAdState {
  final String error;
  GenerateAdFailure(this.error);
}
