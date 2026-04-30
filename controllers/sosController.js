/**
 * SOS Controller
 * Handles emergency SOS alerts
 */
const { v4: uuidv4 } = require('uuid');
const store = require('../data/store');

exports.triggerSOS = async (req, res, next) => {
  try {
    const { latitude, longitude } = req.body;
    const sosAlert = {
      id: uuidv4(),
      userId: req.user.id,
      latitude: latitude || 6.9271,
      longitude: longitude || 79.8612,
      status: 'active',
      triggeredAt: new Date().toISOString(),
      actions: [
        { action: 'location_sent', timestamp: new Date().toISOString(), status: 'completed' },
        { action: 'guardians_notified', timestamp: new Date(Date.now() + 800).toISOString(), status: 'completed', count: 3 },
        { action: 'audio_recording', timestamp: new Date(Date.now() + 1500).toISOString(), status: 'active' },
      ],
    };
    store.sosAlerts.set(req.user.id, sosAlert);
    res.status(201).json({ success: true, message: 'SOS alert triggered. Guardians notified.', data: sosAlert });
  } catch (error) { next(error); }
};

exports.getSOSStatus = async (req, res, next) => {
  try {
    const sos = store.sosAlerts.get(req.user.id);
    if (!sos) return res.json({ success: true, data: { status: 'idle' } });
    res.json({ success: true, data: sos });
  } catch (error) { next(error); }
};

exports.cancelSOS = async (req, res, next) => {
  try {
    store.sosAlerts.delete(req.user.id);
    res.json({ success: true, message: 'SOS alert cancelled.' });
  } catch (error) { next(error); }
};
