/**
 * Incident Controller
 * Handles incident reporting and retrieval
 */

const { v4: uuidv4 } = require('uuid');
const store = require('../data/store');

// Valid incident types
const VALID_TYPES = ['harassment', 'theft', 'stalking', 'poorLighting', 'suspiciousActivity', 'other'];

/**
 * GET /api/incidents
 * Get all incidents (with optional filters)
 */
exports.getIncidents = async (req, res, next) => {
  try {
    const { type, lat, lng, radius, limit } = req.query;

    let incidents = [...store.incidents];

    // Filter by type
    if (type && VALID_TYPES.includes(type)) {
      incidents = incidents.filter(inc => inc.type === type);
    }

    // Filter by proximity (basic distance check)
    if (lat && lng && radius) {
      const userLat = parseFloat(lat);
      const userLng = parseFloat(lng);
      const radiusKm = parseFloat(radius);

      incidents = incidents.filter(inc => {
        const distance = getDistanceKm(userLat, userLng, inc.latitude, inc.longitude);
        return distance <= radiusKm;
      });
    }

    // Sort by most recent
    incidents.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

    // Limit results
    if (limit) {
      incidents = incidents.slice(0, parseInt(limit));
    }

    res.json({
      success: true,
      data: incidents,
      count: incidents.length,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * GET /api/incidents/:id
 * Get a specific incident
 */
exports.getIncident = async (req, res, next) => {
  try {
    const incident = store.incidents.find(inc => inc.id === req.params.id);

    if (!incident) {
      return res.status(404).json({
        success: false,
        message: 'Incident not found.',
      });
    }

    res.json({
      success: true,
      data: incident,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/incidents
 * Report a new incident
 */
exports.createIncident = async (req, res, next) => {
  try {
    const { type, description, latitude, longitude, imageUrl } = req.body;

    if (!VALID_TYPES.includes(type)) {
      return res.status(400).json({
        success: false,
        message: `Invalid incident type. Valid types: ${VALID_TYPES.join(', ')}`,
      });
    }

    const incident = {
      id: uuidv4(),
      type,
      description,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      timestamp: new Date().toISOString(),
      imageUrl: imageUrl || null,
      reportedBy: req.user ? req.user.id : 'Anonymous',
    };

    store.incidents.push(incident);

    res.status(201).json({
      success: true,
      message: 'Incident reported successfully. Thank you for keeping everyone safe!',
      data: incident,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * DELETE /api/incidents/:id
 * Delete an incident (admin only in production)
 */
exports.deleteIncident = async (req, res, next) => {
  try {
    const index = store.incidents.findIndex(inc => inc.id === req.params.id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'Incident not found.',
      });
    }

    store.incidents.splice(index, 1);

    res.json({
      success: true,
      message: 'Incident deleted successfully.',
    });
  } catch (error) {
    next(error);
  }
};

// Helper: Haversine distance calculation
function getDistanceKm(lat1, lon1, lat2, lon2) {
  const R = 6371;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

function toRad(deg) {
  return deg * (Math.PI / 180);
}
