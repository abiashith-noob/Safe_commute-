const router = require('express').Router();
const { authenticate } = require('../middleware/auth');
const ctrl = require('../controllers/aiController');

router.post('/safety-advice', authenticate, ctrl.getSafetyAdvice);
router.post('/chat', authenticate, ctrl.chatWithAssistant);

module.exports = router;
