/**
 * AI Controller
 * Handles AI safety advice and chat using Google Gemini
 */
const { GoogleGenerativeAI } = require('@google/generative-ai');

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
let model = null;

if (GEMINI_API_KEY) {
  const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
  model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
}

exports.getSafetyAdvice = async (req, res, next) => {
  try {
    const { location, time, recentIncidents } = req.body;
    const prompt = `As a Personal Safety Assistant for women commuting, provide concise safety advice.\nLocation: ${location || 'Unknown'}\nTime: ${time || 'Now'}\nRecent Incidents: ${(recentIncidents || []).join(', ') || 'None'}\nFormat: short paragraph + 3 bullet points. Focus on situational awareness, route choices, emergency preparedness.`;

    if (!model) {
      return res.json({ success: true, data: { advice: 'AI service not configured. Stay alert, trust your instincts, and keep emergency contacts ready.' } });
    }

    const result = await model.generateContent(prompt);
    const advice = result.response.text() || 'Stay alert and trust your instincts.';
    res.json({ success: true, data: { advice } });
  } catch (error) {
    res.json({ success: true, data: { advice: 'Error connecting to AI. Stay in well-lit areas and keep your phone charged.' } });
  }
};

exports.chatWithAssistant = async (req, res, next) => {
  try {
    const { message, context } = req.body;
    const prompt = `You are 'SafeGuardian AI', a supportive safety assistant.\nUser: ${message}\nContext: ${context || 'General safety chat'}\nProvide helpful, empathetic safety advice. Keep responses brief and mobile-friendly.`;

    if (!model) {
      return res.json({ success: true, data: { reply: 'AI service not configured. For emergencies, use the SOS button or call emergency services.' } });
    }

    const result = await model.generateContent(prompt);
    const reply = result.response.text() || "I'm here to help. Could you rephrase your question?";
    res.json({ success: true, data: { reply } });
  } catch (error) {
    res.json({ success: true, data: { reply: "Having trouble connecting. Remember to stay in well-lit areas!" } });
  }
};
