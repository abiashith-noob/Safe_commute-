/**
 * Safety Zone Controller
 * Handles safety zone data retrieval
 */
const store = require('../data/store');

exports.getSafetyZones = async (req, res, next) => {
  try {
    res.json({ success: true, data: store.safetyZones, count: store.safetyZones.length });
  } catch (error) { next(error); }
};

exports.getSafetyZone = async (req, res, next) => {
  try {
    const zone = store.safetyZones.find(z => z.id === req.params.id);
    if (!zone) return res.status(404).json({ success: false, message: 'Safety zone not found.' });
    res.json({ success: true, data: zone });
  } catch (error) { next(error); }
};

exports.checkSafetyLevel = async (req, res, next) => {
  try {
    const { lat, lng } = req.query;
    if (!lat || !lng) return res.status(400).json({ success: false, message: 'lat and lng required.' });
    const latitude = parseFloat(lat), longitude = parseFloat(lng);
    let safetyLevel = 'safe';
    if (latitude > 6.925 && longitude > 79.855) safetyLevel = 'safe';
    else if (latitude > 6.920) safetyLevel = 'moderate';
    else safetyLevel = 'risky';
    res.json({ success: true, data: { latitude, longitude, safetyLevel, address: 'Colombo Fort, Colombo 01' } });
  } catch (error) { next(error); }
};
