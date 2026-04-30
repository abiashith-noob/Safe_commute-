/**
 * User Controller
 * Handles user profile CRUD operations
 */

const store = require('../data/store');

/**
 * GET /api/users/me
 * Get current user's profile
 */
exports.getProfile = async (req, res, next) => {
  try {
    const user = store.users.get(req.user.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const { password: _, ...safeUser } = user;

    res.json({
      success: true,
      data: safeUser,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PUT /api/users/me
 * Update current user's profile
 */
exports.updateProfile = async (req, res, next) => {
  try {
    const user = store.users.get(req.user.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const { fullName, phone, photoUrl, locationTrackingEnabled } = req.body;

    // Update fields if provided
    if (fullName !== undefined) user.fullName = fullName;
    if (phone !== undefined) user.phone = phone;
    if (photoUrl !== undefined) user.photoUrl = photoUrl;
    if (locationTrackingEnabled !== undefined) user.locationTrackingEnabled = locationTrackingEnabled;

    store.users.set(req.user.id, user);

    const { password: _, ...safeUser } = user;

    res.json({
      success: true,
      message: 'Profile updated successfully.',
      data: safeUser,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * DELETE /api/users/me
 * Delete current user's account
 */
exports.deleteAccount = async (req, res, next) => {
  try {
    store.users.delete(req.user.id);
    store.guardians.delete(req.user.id);
    store.sosAlerts.delete(req.user.id);
    store.checkInSessions.delete(req.user.id);

    res.json({
      success: true,
      message: 'Account deleted successfully.',
    });
  } catch (error) {
    next(error);
  }
};
