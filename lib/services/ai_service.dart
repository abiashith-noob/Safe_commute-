import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class AIService {
  static const String _apiKey = 'AIzaSyDQ-7RUnloc3bi8Z-VPPhmJ8kpj0wVI4Pc';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> getSafetyAdvice(String location, String time, List<String> recentIncidents) async {
    final prompt = '''
    As a specialized Personal Safety Assistant for women commuting, provide concise, actionable safety advice for the following scenario:
    
    Location: $location
    Time: $time
    Recent Nearby Incidents: ${recentIncidents.join(", ")}
    
    Format the response as a short paragraph followed by 3 bullet points. 
    Focus on situational awareness, route choices, and emergency preparedness.
    Keep the tone calm but professional.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "I'm sorry, I couldn't generate safety advice at this moment. Stay alert and trust your instincts.";
    } catch (e) {
      return "Error connecting to AI Safety Engine. Please ensure you're in a safe area and check your connection.";
    }
  }

  Future<String> chatWithAssistant(String message, String currentContext) async {
    final prompt = '''
    You are 'SafeGuardian AI', a supportive and knowledgeable safety assistant. 
    User Question: $message
    Current Context: $currentContext
    
    Provide helpful, empathetic, and specific safety advice. 
    If the user is in immediate danger, prioritize telling them to use the SOS button or contact emergency services.
    Keep responses brief and mobile-friendly.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "I'm here to help. Could you please rephrase your question?";
    } catch (e) {
      return "I'm having trouble connecting to my brain right now. Remember to stay in well-lit areas!";
    }
  }
}
