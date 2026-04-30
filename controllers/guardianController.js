/**
 * Guardian Controller
 * Handles guardian circle CRUD operations and location sharing
 */

const { v4: uuidv4 } = require('uuid');
const store = require('../data/store');

/**
 * GET /api/guardians
 * Get all guardians for the authenticated user
 */
exports.getGuardians = async (req, res, next) => {
  try {
    let guardians = store.guardians.get(req.user.id);

    // Return default mock guardians if none exist
    if (!guardians || guardians.length === 0) {
      guardians = [
        {
          id: 'g1',
          name: 'Mom',
          phone: '+1 (555) 111-2222',
          relation: 'Mother',
          isActive: true,
          isLocationSharing: false,
          sharingExpiresAt: null,
        },
        {
          id: 'g2',
          name: 'Best Friend - Priya',
          phone: '+1 (555) 333-4444',
          relation: 'Friend',
          isActive: true,
          isLocationSharing: false,
          sharingExpiresAt: null,
        },
        {
          id: 'g3',
          name: 'Brother - Arun',
          phone: '+1 (555) 555-6666',
          relation: 'Brother',
          isActive: false,
          isLocationSharing: false,
          sharingExpiresAt: null,
        },
      ];
      store.guardians.set(req.user.id, guardians);
    }

    res.json({
      success: true,
      data: guardians,
      count: guardians.length,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/guardians
 * Add a new guardian
 */
exports.addGuardian = async (req, res, next) => {
  try {
    const { name, phone, relation } = req.body;

    const guardian = {
      id: uuidv4(),
      name,
      phone,
      relation: relation || 'Friend',
      isActive: true,
      isLocationSharing: false,
      sharingExpiresAt: null,
    };

    let guardians = store.guardians.get(req.user.id) || [];
    guardians.push(guardian);
    store.guardians.set(req.user.id, guardians);

    res.status(201).json({
      success: true,
      message: 'Guardian added successfully.',
      data: guardian,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PUT /api/guardians/:id
 * Update a guardian
 */
exports.updateGuardian = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, phone, relation, isActive } = req.body;

    let guardians = store.guardians.get(req.user.id) || [];
    const index = guardians.findIndex(g => g.id === id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'Guardian not found.',
      });
    }

    if (name !== undefined) guardians[index].name = name;
    if (phone !== undefined) guardians[index].phone = phone;
    if (relation !== undefined) guardians[index].relation = relation;
    if (isActive !== undefined) guardians[index].isActive = isActive;

    store.guardians.set(req.user.id, guardians);

    res.json({
      success: true,
      message: 'Guardian updated successfully.',
      data: guardians[index],
    });
  } catch (error) {
    next(error);
  }
};

/**
 * DELETE /api/guardians/:id
 * Remove a guardian
 */
exports.removeGuardian = async (req, res, next) => {
  try {
    const { id } = req.params;

    let guardians = store.guardians.get(req.user.id) || [];
    const filtered = guardians.filter(g => g.id !== id);

    if (filtered.length === guardians.length) {
      return res.status(404).json({
        success: false,
        message: 'Guardian not found.',
      });
    }

    store.guardians.set(req.user.id, filtered);

    res.json({
      success: true,
      message: 'Guardian removed successfully.',
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PATCH /api/guardians/:id/location-sharing
 * Toggle location sharing for a guardian
 */
exports.toggleLocationSharing = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { enabled, durationMinutes } = req.body;

    let guardians = store.guardians.get(req.user.id) || [];
    const index = guardians.findIndex(g => g.id === id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'Guardian not found.',
      });
    }

    guardians[index].isLocationSharing = enabled;
    guardians[index].sharingExpiresAt = enabled && durationMinutes
      ? new Date(Date.now() + durationMinutes * 60 * 1000).toISOString()
      : null;

    store.guardians.set(req.user.id, guardians);

    res.json({
      success: true,
      message: enabled ? 'Location sharing enabled.' : 'Location sharing disabled.',
      data: guardians[index],
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/guardians/alert-all
 * Alert all active guardians (used during SOS)
 */
exports.alertAllGuardians = async (req, res, next) => {
  try {
    const guardians = store.guardians.get(req.user.id) || [];
    const activeGuardians = guardians.filter(g => g.isActive);

    // In production, send push notifications / SMS to all active guardians
    res.json({
      success: true,
      message: `${activeGuardians.length} guardian(s) have been alerted.`,
      data: {
        alertedCount: activeGuardians.length,
        guardians: activeGuardians.map(g => ({ id: g.id, name: g.name })),
      },
    });
  } catch (error) {
    next(error);
  }
};
