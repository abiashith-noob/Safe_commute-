# SafeCommute AI 🛡️

A safety-focused commute application for women, powered by AI. This is our academic team project designed to provide safe routing, emergency SOS, and real-time safety monitoring.

## 👥 Team Members
- **Member 1** - Frontend Lead
- **Member 2** - Frontend (Maps & Routes)
- **Member 3** - Frontend (Safety Features)
- **Member 4** - Frontend (Profile & Guardian)
- **Member 5** - Backend Lead
- **Member 6** - Backend (Core APIs)
- **Member 7** - Backend (Real-time Features)
- **Member 8** - AI & Integration

## 🛠️ Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** Node.js, Express.js
- **AI:** Google Gemini
- **Maps:** OpenStreetMap (via flutter_map)

## ✨ Key Features
- **User Authentication:** Simple signup and login.
- **Safety Map & Routing:** Find the safest routes based on AI analysis.
- **Emergency SOS:** Instantly alert your guardian circle with your location.
- **Safety Check-In:** Periodic check-ins to ensure you've reached safely.
- **Incident Reporting:** Report unsafe areas to help the community.
- **AI Assistant:** Chat with an AI for safety advice.

## 🚀 How to Run

### 1. Start the Backend
1. Open your terminal and navigate to the `backend` folder:
   ```bash
   cd backend
   ```
2. Install the necessary packages:
   ```bash
   npm install
   ```
3. Start the server (it will run on `http://localhost:3000`):
   ```bash
   npm run dev
   ```

### 2. Start the Frontend
1. Open a new terminal window and navigate to the `frontend` folder:
   ```bash
   cd frontend
   ```
2. Get the Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on an emulator or connected device:
   ```bash
   flutter run
   ```

> **Note for connecting frontend to backend:** 
> If you are using an Android Emulator, make sure the API URL in `frontend/lib/services/api_service.dart` is set to `http://10.0.2.2:3000/api` so it can reach your local backend!
