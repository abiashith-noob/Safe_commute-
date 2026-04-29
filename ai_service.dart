import 'api_service.dart';

/// AI Service that calls the backend AI endpoints.
/// The backend handles the Gemini API integration.
class AIService {
  Future<String> getSafetyAdvice(
      String location, String time, List<String> recentIncidents) async {
    final response = await ApiService.post('/ai/safety-advice', body: {
      'location': location,
      'time': time,
      'recentIncidents': recentIncidents,
    });

    if (response['success'] == true && response['data'] != null) {
      return response['data']['advice'] ??
          "Stay alert and trust your instincts.";
    }
    return "Error connecting to AI Safety Engine. Please ensure you're in a safe area.";
  }

  Future<String> chatWithAssistant(String message, String currentContext) async {
    final response = await ApiService.post('/ai/chat', body: {
      'message': message,
      'context': currentContext,
    });

    if (response['success'] == true && response['data'] != null) {
      return response['data']['reply'] ??
          "I'm here to help. Could you please rephrase your question?";
    }
    return "I'm having trouble connecting. Remember to stay in well-lit areas!";
  }
}
