const router = require('express').Router();
const { authenticate } = require('../middleware/auth');
const ctrl = require('../controllers/userController');

router.get('/me', authenticate, ctrl.getProfile);
router.put('/me', authenticate, ctrl.updateProfile);
router.delete('/me', authenticate, ctrl.deleteAccount);

module.exports = router;
