/**
 * Auth Controller
 * Handles user registration, login, and password reset
 */

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const store = require('../data/store');
const { JWT_SECRET } = require('../middleware/auth');

const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

/**
 * POST /api/auth/signup
 * Register a new user
 */
exports.signUp = async (req, res, next) => {
  try {
    const { fullName, email, password } = req.body;

    // Check if email already exists
    for (const [, user] of store.users) {
      if (user.email === email) {
        return res.status(409).json({
          success: false,
          message: 'An account with this email already exists.',
        });
      }
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const userId = uuidv4();
    const user = {
      id: userId,
      fullName,
      email,
      phone: '',
      photoUrl: null,
      locationTrackingEnabled: false,
      password: hashedPassword,
      createdAt: new Date().toISOString(),
    };

    store.users.set(userId, user);

    // Generate token
    const token = jwt.sign(
      { id: userId, email: user.email },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    );

    // Return user without password
    const { password: _, ...safeUser } = user;

    res.status(201).json({
      success: true,
      message: 'Account created successfully',
      data: {
        user: safeUser,
        token,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/auth/signin
 * Authenticate user and return JWT
 */
exports.signIn = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    let foundUser = null;
    for (const [, user] of store.users) {
      if (user.email === email) {
        foundUser = user;
        break;
      }
    }

    // For demo: if no users exist, create a demo user
    if (!foundUser && store.users.size === 0) {
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash('demo123', salt);
      const demoUser = {
        id: 'demo_user_001',
        fullName: 'Sarah Johnson',
        email: email,
        phone: '+1 (555) 234-5678',
        photoUrl: null,
        locationTrackingEnabled: true,
        password: hashedPassword,
        createdAt: new Date().toISOString(),
      };
      store.users.set(demoUser.id, demoUser);
      foundUser = demoUser;
    }

    if (!foundUser) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    // Verify password (for demo, accept any password)
    const isValidPassword = await bcrypt.compare(password, foundUser.password);
    if (!isValidPassword && process.env.NODE_ENV !== 'development') {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    // Generate token
    const token = jwt.sign(
      { id: foundUser.id, email: foundUser.email },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    );

    const { password: _, ...safeUser } = foundUser;

    res.json({
      success: true,
      message: 'Signed in successfully',
      data: {
        user: safeUser,
        token,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/auth/reset-password
 * Send password reset (mock)
 */
exports.resetPassword = async (req, res, next) => {
  try {
    const { email } = req.body;

    res.json({
      success: true,
      message: 'Password reset link sent to your email.',
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/auth/signout
 * Sign out user (client should discard token)
 */
exports.signOut = async (req, res, next) => {
  try {
    res.json({
      success: true,
      message: 'Signed out successfully.',
    });
  } catch (error) {
    next(error);
  }
};
