/**
 * Route Controller
 * Handles route planning with safety scoring
 */

const { v4: uuidv4 } = require('uuid');
const store = require('../data/store');

/**
 * POST /api/routes/search
 * Search for routes between two points with safety analysis
 */
exports.searchRoutes = async (req, res, next) => {
  try {
    const { pickupLocation, destination, pickupLat, pickupLng, destLat, destLng } = req.body;

    // Generate mock routes with safety analysis
    const routes = [
      {
        id: uuidv4(),
        name: 'Via Main Road & Hospital Junction',
        safetyLevel: 'safest',
        distanceKm: 5.8,
        durationMinutes: 22,
        lightingScore: 5,
        crowdScore: 4,
        incidentCount: 0,
        points: [
          { lat: 6.9271, lng: 79.8612 },
          { lat: 6.9290, lng: 79.8580 },
          { lat: 6.9310, lng: 79.8550 },
          { lat: 6.9330, lng: 79.8520 },
          { lat: 6.9350, lng: 79.8500 },
          { lat: 6.9370, lng: 79.8480 },
          { lat: 6.9390, lng: 79.8460 },
        ],
      },
      {
        id: uuidv4(),
        name: 'Via City Center & Park Road',
        safetyLevel: 'balanced',
        distanceKm: 4.5,
        durationMinutes: 18,
        lightingScore: 3,
        crowdScore: 3,
        incidentCount: 2,
        points: [
          { lat: 6.9271, lng: 79.8612 },
          { lat: 6.9260, lng: 79.8590 },
          { lat: 6.9250, lng: 79.8560 },
          { lat: 6.9280, lng: 79.8530 },
          { lat: 6.9320, lng: 79.8500 },
          { lat: 6.9360, lng: 79.8475 },
          { lat: 6.9390, lng: 79.8460 },
        ],
      },
      {
        id: uuidv4(),
        name: 'Via Shortcut Lane',
        safetyLevel: 'fastest',
        distanceKm: 3.2,
        durationMinutes: 12,
        lightingScore: 2,
        crowdScore: 1,
        incidentCount: 5,
        points: [
          { lat: 6.9271, lng: 79.8612 },
          { lat: 6.9280, lng: 79.8570 },
          { lat: 6.9310, lng: 79.8530 },
          { lat: 6.9350, lng: 79.8490 },
          { lat: 6.9390, lng: 79.8460 },
        ],
      },
    ];

    res.json({
      success: true,
      data: {
        pickup: pickupLocation || 'Current Location',
        destination: destination || 'Destination',
        routes,
        recommendedRouteId: routes[0].id,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * GET /api/routes/:id
 * Get route details
 */
exports.getRoute = async (req, res, next) => {
  try {
    // In production, fetch from database
    res.json({
      success: true,
      message: 'Route details would be fetched from database.',
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/routes/:id/start-navigation
 * Start navigation on a route
 */
exports.startNavigation = async (req, res, next) => {
  try {
    res.json({
      success: true,
      message: 'Navigation started. Real-time tracking enabled.',
      data: {
        routeId: req.params.id,
        startedAt: new Date().toISOString(),
        status: 'navigating',
      },
    });
  } catch (error) {
    next(error);
  }
};
