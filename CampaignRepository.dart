import 'package:shared_preferences/shared_preferences.dart';

class CampaignRepository {
  Future<void> saveDraft(Map<String, String> draftData) async {
    final prefs = await SharedPreferences.getInstance();
    draftData.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  Future<Map<String, String>> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "subject": prefs.getString("subject") ?? "",
      "previewText": prefs.getString("previewText") ?? "",
      "fromName": prefs.getString("fromName") ?? "",
      "fromEmail": prefs.getString("fromEmail") ?? "",
    };
  }
}
