/**
 * JWT Authentication Middleware
 * Verifies JWT token from Authorization header
 */

const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'safe_commute_dev_secret_key_2024';

/**
 * Middleware to authenticate requests using JWT
 */
const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Access denied. No token provided.',
      });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, JWT_SECRET);

    req.user = decoded;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Token expired. Please sign in again.',
      });
    }

    return res.status(401).json({
      success: false,
      message: 'Invalid token.',
    });
  }
};

/**
 * Optional authentication - attaches user if token exists but doesn't block
 */
const optionalAuth = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      const decoded = jwt.verify(token, JWT_SECRET);
      req.user = decoded;
    }
  } catch (error) {
    // Token invalid, but we continue without user context
  }
  next();
};

module.exports = { authenticate, optionalAuth, JWT_SECRET };
