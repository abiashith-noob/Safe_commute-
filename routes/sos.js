const router = require('express').Router();
const { authenticate } = require('../middleware/auth');
const ctrl = require('../controllers/sosController');

router.post('/trigger', authenticate, ctrl.triggerSOS);
router.get('/status', authenticate, ctrl.getSOSStatus);
router.post('/cancel', authenticate, ctrl.cancelSOS);

module.exports = router;
