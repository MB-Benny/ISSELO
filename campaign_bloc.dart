import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/CampaignRepository.dart';
import 'campaign_event.dart';
import 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignRepository repository;

  CampaignBloc(this.repository) : super(CampaignInitialState()) {
    on<LoadDraftEvent>((event, emit) async {
      emit(CampaignLoadingState());
      final draftData = await repository.loadDraft();
      emit(CampaignLoadedState(draftData));
    });

    on<SaveDraftEvent>((event, emit) async {
      await repository.saveDraft(event.draftData);
      emit(CampaignSavedState());
    });

    on<ValidateFormEvent>((event, emit) {
      emit(CampaignValidationState(event.isValid));
    });
  }
}
