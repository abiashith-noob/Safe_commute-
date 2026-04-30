/**
 * In-Memory Data Store
 * 
 * Simulates a database using in-memory storage.
 * In production, replace with Firebase Firestore, MongoDB, or PostgreSQL.
 * 
 * This module is a singleton — all controllers share the same data instance.
 */

const store = {
  // Users collection: Map<userId, UserObject>
  users: new Map(),

  // Guardians collection: Map<userId, GuardianObject[]>
  guardians: new Map(),

  // Incidents collection: IncidentObject[]
  incidents: [],

  // Safety Zones (static data)
  safetyZones: [
    {
      id: 'zone_1',
      latitude: 6.9271,
      longitude: 79.8612,
      radiusMeters: 500,
      level: 'safe',
      name: 'Colombo Fort Area',
    },
    {
      id: 'zone_2',
      latitude: 6.9200,
      longitude: 79.8500,
      radiusMeters: 400,
      level: 'safe',
      name: 'Pettah Market Zone',
    },
    {
      id: 'zone_3',
      latitude: 6.9340,
      longitude: 79.8500,
      radiusMeters: 300,
      level: 'moderate',
      name: 'Maradana Junction',
    },
    {
      id: 'zone_4',
      latitude: 6.9150,
      longitude: 79.8700,
      radiusMeters: 350,
      level: 'risky',
      name: 'Slave Island Back Streets',
    },
    {
      id: 'zone_5',
      latitude: 6.9100,
      longitude: 79.8400,
      radiusMeters: 450,
      level: 'safe',
      name: 'Kollupitiya Main Road',
    },
    {
      id: 'zone_6',
      latitude: 6.9380,
      longitude: 79.8650,
      radiusMeters: 250,
      level: 'moderate',
      name: 'Borella Side Roads',
    },
    {
      id: 'zone_7',
      latitude: 6.9050,
      longitude: 79.8550,
      radiusMeters: 300,
      level: 'risky',
      name: 'Wellawatte Underpass',
    },
  ],

  // SOS alerts: Map<userId, SOSObject>
  sosAlerts: new Map(),

  // Check-in sessions: Map<userId, CheckInObject>
  checkInSessions: new Map(),

  // Seed mock incidents
  seedData() {
    if (this.incidents.length === 0) {
      this.incidents = [
        {
          id: 'inc_001',
          type: 'poorLighting',
          description: 'Street lights not working on Oak Avenue',
          latitude: 6.9271,
          longitude: 79.8612,
          timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
          imageUrl: null,
          reportedBy: 'Anonymous',
        },
        {
          id: 'inc_002',
          type: 'harassment',
          description: 'Cat-calling reported near Market Square',
          latitude: 6.9340,
          longitude: 79.8500,
          timestamp: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString(),
          imageUrl: null,
          reportedBy: 'Anonymous',
        },
        {
          id: 'inc_003',
          type: 'suspiciousActivity',
          description: 'Suspicious person loitering near bus stop',
          latitude: 6.9200,
          longitude: 79.8700,
          timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
          imageUrl: null,
          reportedBy: 'Anonymous',
        },
        {
          id: 'inc_004',
          type: 'theft',
          description: 'Phone snatching reported',
          latitude: 6.9150,
          longitude: 79.8550,
          timestamp: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
          imageUrl: null,
          reportedBy: 'Anonymous',
        },
      ];
    }
  },
};

// Seed initial data
store.seedData();

module.exports = store;
