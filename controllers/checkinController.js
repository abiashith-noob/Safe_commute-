/**
 * Check-In Controller
 * Handles safety check-in sessions
 */
const store = require('../data/store');

exports.startCheckIn = async (req, res, next) => {
  try {
    const { intervalMinutes } = req.body;
    const session = {
      userId: req.user.id,
      status: 'active',
      intervalMinutes: intervalMinutes || 30,
      startedAt: new Date().toISOString(),
      nextCheckIn: new Date(Date.now() + (intervalMinutes || 30) * 60 * 1000).toISOString(),
      missedCount: 0,
    };
    store.checkInSessions.set(req.user.id, session);
    res.status(201).json({ success: true, message: 'Check-in started.', data: session });
  } catch (error) { next(error); }
};

exports.getCheckInStatus = async (req, res, next) => {
  try {
    const session = store.checkInSessions.get(req.user.id);
    if (!session) return res.json({ success: true, data: { status: 'inactive' } });
    res.json({ success: true, data: session });
  } catch (error) { next(error); }
};

exports.confirmSafe = async (req, res, next) => {
  try {
    const session = store.checkInSessions.get(req.user.id);
    if (!session) return res.status(404).json({ success: false, message: 'No active check-in session.' });
    session.status = 'active';
    session.nextCheckIn = new Date(Date.now() + session.intervalMinutes * 60 * 1000).toISOString();
    store.checkInSessions.set(req.user.id, session);
    res.json({ success: true, message: 'Safety confirmed. Next check-in scheduled.', data: session });
  } catch (error) { next(error); }
};

exports.stopCheckIn = async (req, res, next) => {
  try {
    store.checkInSessions.delete(req.user.id);
    res.json({ success: true, message: 'Check-in stopped.' });
  } catch (error) { next(error); }
};
