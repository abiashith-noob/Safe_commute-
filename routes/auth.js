const router = require('express').Router();
const { body } = require('express-validator');
const ctrl = require('../controllers/authController');

router.post('/signup', [
  body('fullName').trim().notEmpty().withMessage('Full name is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
], ctrl.signUp);

router.post('/signin', [
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').notEmpty().withMessage('Password is required'),
], ctrl.signIn);

router.post('/reset-password', [
  body('email').isEmail().withMessage('Valid email is required'),
], ctrl.resetPassword);

router.post('/signout', ctrl.signOut);

module.exports = router;
