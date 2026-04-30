const router = require('express').Router();
const { optionalAuth } = require('../middleware/auth');
const ctrl = require('../controllers/safetyZoneController');

router.get('/', optionalAuth, ctrl.getSafetyZones);
router.get('/check', optionalAuth, ctrl.checkSafetyLevel);
router.get('/:id', optionalAuth, ctrl.getSafetyZone);

module.exports = router;
