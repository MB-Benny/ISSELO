abstract class CampaignState {}

class CampaignInitialState extends CampaignState {}

class CampaignLoadingState extends CampaignState {}

class CampaignLoadedState extends CampaignState {
  final Map<String, String> draftData;
  CampaignLoadedState(this.draftData);
}

class CampaignSavedState extends CampaignState {}

class CampaignValidationState extends CampaignState {
  final bool isValid;
  CampaignValidationState(this.isValid);
}
