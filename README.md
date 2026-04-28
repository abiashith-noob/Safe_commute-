# SafeCommute AI 🛡️

> Intelligent safety-focused commute application for women — powered by AI

## 📁 Project Structure

```
safe_commute_ai/
├── frontend/          # Flutter Mobile App (Dart)
│   ├── lib/
│   │   ├── config/        # Theme & routes
│   │   ├── models/        # Data models
│   │   ├── providers/     # State management (Provider)
│   │   ├── screens/       # UI screens
│   │   ├── services/      # API service layer
│   │   └── widgets/       # Reusable widgets
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── backend/           # Node.js REST API (Express)
│   ├── controllers/       # Business logic
│   ├── routes/            # API route definitions
│   ├── middleware/         # Auth middleware (JWT)
│   ├── data/              # In-memory data store
│   ├── server.js          # Entry point
│   └── package.json
│
└── README.md          # This file
```

---

## 👥 Team Member Assignments (8 Members)

| # | Member | Role | Responsible Area | Key Files |
|---|--------|------|-----------------|-----------|
| 1 | **Member 1** | Frontend Lead | Auth screens + Theme system | `frontend/lib/screens/auth/`, `frontend/lib/config/theme.dart` |
| 2 | **Member 2** | Frontend - Maps & Routes | Map screen, Route planner, Map widgets | `frontend/lib/screens/map/`, `frontend/lib/screens/route/` |
| 3 | **Member 3** | Frontend - Safety Features | SOS, Check-in, Incident Report screens | `frontend/lib/screens/sos/`, `frontend/lib/screens/checkin/`, `frontend/lib/screens/incident/` |
| 4 | **Member 4** | Frontend - Profile & Guardian | Profile screens, Guardian circle, widgets | `frontend/lib/screens/profile/`, `frontend/lib/screens/guardian/` |
| 5 | **Member 5** | Backend Lead | Server setup, Auth API, User API | `backend/server.js`, `backend/controllers/authController.js`, `backend/routes/auth.js` |
| 6 | **Member 6** | Backend - Core APIs | Guardian, Incident, Safety Zone APIs | `backend/controllers/guardianController.js`, `backend/controllers/incidentController.js` |
| 7 | **Member 7** | Backend - Real-time Features | SOS, Check-in, Route APIs | `backend/controllers/sosController.js`, `backend/controllers/checkinController.js`, `backend/controllers/routeController.js` |
| 8 | **Member 8** | AI & Integration | AI service, API integration, Testing | `backend/controllers/aiController.js`, `frontend/lib/services/api_service.dart`, `frontend/lib/screens/ai/` |

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** v18+ and npm
- **Flutter** SDK 3.10+
- **Android Studio** or **VS Code** with Flutter extension

### Backend Setup

```bash
cd backend
cp .env.example .env        # Configure environment variables
npm install                  # Install dependencies
npm run dev                  # Start development server (port 3000)
```

The API will be available at `http://localhost:3000/api`

### Frontend Setup

```bash
cd frontend
flutter pub get              # Install dependencies
flutter run                  # Run on connected device/emulator
```

> **Note:** Update the `baseUrl` in `frontend/lib/services/api_service.dart`:
> - Android Emulator: `http://10.0.2.2:3000/api`
> - iOS Simulator: `http://localhost:3000/api`
> - Physical Device: `http://<your-ip>:3000/api`

---

## 📡 API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/auth/signup` | ❌ | Register new user |
| `POST` | `/api/auth/signin` | ❌ | Login user |
| `POST` | `/api/auth/reset-password` | ❌ | Reset password |
| `GET` | `/api/users/me` | ✅ | Get user profile |
| `PUT` | `/api/users/me` | ✅ | Update profile |
| `GET` | `/api/guardians` | ✅ | List guardians |
| `POST` | `/api/guardians` | ✅ | Add guardian |
| `PUT` | `/api/guardians/:id` | ✅ | Update guardian |
| `DELETE` | `/api/guardians/:id` | ✅ | Remove guardian |
| `PATCH` | `/api/guardians/:id/location-sharing` | ✅ | Toggle location sharing |
| `POST` | `/api/guardians/alert-all` | ✅ | Alert all guardians |
| `GET` | `/api/incidents` | 🔓 | List incidents |
| `POST` | `/api/incidents` | ✅ | Report incident |
| `POST` | `/api/routes/search` | ✅ | Search safe routes |
| `GET` | `/api/safety-zones` | 🔓 | Get safety zones |
| `GET` | `/api/safety-zones/check` | 🔓 | Check safety level |
| `POST` | `/api/sos/trigger` | ✅ | Trigger SOS alert |
| `GET` | `/api/sos/status` | ✅ | Get SOS status |
| `POST` | `/api/sos/cancel` | ✅ | Cancel SOS |
| `POST` | `/api/checkin/start` | ✅ | Start check-in |
| `GET` | `/api/checkin/status` | ✅ | Check-in status |
| `POST` | `/api/checkin/confirm` | ✅ | Confirm safe |
| `POST` | `/api/checkin/stop` | ✅ | Stop check-in |
| `POST` | `/api/ai/safety-advice` | ✅ | Get AI safety advice |
| `POST` | `/api/ai/chat` | ✅ | Chat with AI assistant |

> ✅ = JWT Required | 🔓 = Optional Auth | ❌ = No Auth

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter (Dart), Provider, flutter_map, Google Fonts |
| **Backend** | Node.js, Express.js, JWT Authentication |
| **AI** | Google Gemini 1.5 Flash |
| **Maps** | OpenStreetMap (via flutter_map) |

---

## 📋 Features

- 🔐 User Authentication (Sign Up / Sign In)
- 📍 Real-time Location Tracking
- 🗺️ Interactive Safety Map with zone overlays
- 🛣️ AI-powered Safe Route Planning
- 👨‍👩‍👧 Guardian Circle Management
- 🚨 Emergency SOS with guardian alerts
- ✅ Periodic Safety Check-In
- 📝 Community Incident Reporting
- 🤖 AI Safety Assistant (Gemini)
- 📊 Safety scoring (lighting, crowd, incidents)
