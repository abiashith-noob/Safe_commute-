const router = require('express').Router();
const { authenticate, optionalAuth } = require('../middleware/auth');
const ctrl = require('../controllers/incidentController');

router.get('/', optionalAuth, ctrl.getIncidents);
router.get('/:id', optionalAuth, ctrl.getIncident);
router.post('/', authenticate, ctrl.createIncident);
router.delete('/:id', authenticate, ctrl.deleteIncident);

module.exports = router;
