/**
 * SafeCommute AI - Backend Server
 * Express.js REST API for the SafeCommute AI mobile application
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// Import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const guardianRoutes = require('./routes/guardians');
const incidentRoutes = require('./routes/incidents');
const routeRoutes = require('./routes/routes');
const safetyZoneRoutes = require('./routes/safetyZones');
const sosRoutes = require('./routes/sos');
const checkinRoutes = require('./routes/checkin');
const aiRoutes = require('./routes/ai');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Middleware ──────────────────────────────────────────────
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ─── Health Check ───────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'SafeCommute AI Backend is running',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  });
});

// ─── API Routes ─────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/guardians', guardianRoutes);
app.use('/api/incidents', incidentRoutes);
app.use('/api/routes', routeRoutes);
app.use('/api/safety-zones', safetyZoneRoutes);
app.use('/api/sos', sosRoutes);
app.use('/api/checkin', checkinRoutes);
app.use('/api/ai', aiRoutes);

// ─── 404 Handler ────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.method} ${req.originalUrl} not found`,
  });
});

// ─── Global Error Handler ───────────────────────────────────
app.use((err, req, res, next) => {
  console.error('❌ Error:', err.message);
  console.error(err.stack);

  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

// ─── Start Server ───────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🛡️  SafeCommute AI Backend Server`);
  console.log(`   ├── Status: Running`);
  console.log(`   ├── Port: ${PORT}`);
  console.log(`   ├── Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`   └── API Base: http://localhost:${PORT}/api\n`);
});

module.exports = app;
