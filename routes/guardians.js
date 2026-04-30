const router = require('express').Router();
const { authenticate } = require('../middleware/auth');
const ctrl = require('../controllers/guardianController');

router.get('/', authenticate, ctrl.getGuardians);
router.post('/', authenticate, ctrl.addGuardian);
router.put('/:id', authenticate, ctrl.updateGuardian);
router.delete('/:id', authenticate, ctrl.removeGuardian);
router.patch('/:id/location-sharing', authenticate, ctrl.toggleLocationSharing);
router.post('/alert-all', authenticate, ctrl.alertAllGuardians);

module.exports = router;
