const router = require('express').Router();
const { authenticate } = require('../middleware/auth');
const ctrl = require('../controllers/routeController');

router.post('/search', authenticate, ctrl.searchRoutes);
router.get('/:id', authenticate, ctrl.getRoute);
router.post('/:id/start-navigation', authenticate, ctrl.startNavigation);

module.exports = router;
