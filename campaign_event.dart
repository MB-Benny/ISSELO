abstract class CampaignEvent {}

class LoadDraftEvent extends CampaignEvent {}

class SaveDraftEvent extends CampaignEvent {
  final Map<String, String> draftData;
  SaveDraftEvent(this.draftData);
}

class ValidateFormEvent extends CampaignEvent {
  final bool isValid;
  ValidateFormEvent(this.isValid);
}
