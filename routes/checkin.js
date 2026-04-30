const router = require('express').Router();
const { authenticate } = require('../middleware/auth');
const ctrl = require('../controllers/checkinController');

router.post('/start', authenticate, ctrl.startCheckIn);
router.get('/status', authenticate, ctrl.getCheckInStatus);
router.post('/confirm', authenticate, ctrl.confirmSafe);
router.post('/stop', authenticate, ctrl.stopCheckIn);

module.exports = router;
