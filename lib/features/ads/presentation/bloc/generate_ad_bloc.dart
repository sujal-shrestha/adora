import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/generate_ad_usecase.dart';

part 'generate_ad_event.dart';
part 'generate_ad_state.dart';

class GenerateAdBloc extends Bloc<GenerateAdEvent, GenerateAdState> {
  final GenerateAdUseCase useCase;

  GenerateAdBloc(this.useCase) : super(GenerateAdInitial()) {
    on<GenerateAdRequested>(_onRequested);
  }

  Future<void> _onRequested(
  GenerateAdRequested event,
  Emitter<GenerateAdState> emit,
) async {
  emit(GenerateAdLoading());
  try {
    final result = await useCase(event.prompt);
    emit(GenerateAdSuccess(result.imageUrl, result.remainingCredits));
  } catch (e) {
    emit(GenerateAdFailure(e.toString()));
  }
}
}
