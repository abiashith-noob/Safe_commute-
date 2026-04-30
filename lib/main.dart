import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/location_provider.dart';
import 'providers/guardian_provider.dart';
import 'providers/map_provider.dart';
import 'providers/route_provider.dart';
import 'providers/incident_provider.dart';
import 'providers/sos_provider.dart';
import 'providers/checkin_provider.dart';

import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/main_shell.dart';
import 'screens/route/route_planner_screen.dart';
import 'screens/map/safety_map_screen.dart';
import 'screens/guardian/guardian_circle_screen.dart';
import 'screens/sos/sos_screen.dart';
import 'screens/checkin/safety_checkin_screen.dart';
import 'screens/incident/incident_report_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/safety_preferences_screen.dart';
import 'screens/profile/notifications_screen.dart';
import 'screens/profile/trip_history_screen.dart';
import 'screens/profile/help_support_screen.dart';
import 'screens/profile/about_screen.dart';
import 'screens/ai/ai_assistant_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SafeCommuteApp());
}

class SafeCommuteApp extends StatelessWidget {
  const SafeCommuteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => GuardianProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => IncidentProvider()),
        ChangeNotifierProvider(create: (_) => SOSProvider()),
        ChangeNotifierProvider(create: (_) => CheckInProvider()),
      ],
      child: MaterialApp(
        title: 'SafeCommute AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.signIn,
        routes: {
          AppRoutes.signUp: (_) => const SignUpScreen(),
          AppRoutes.signIn: (_) => const SignInScreen(),
          AppRoutes.profileSetup: (_) => const ProfileSetupScreen(),
          AppRoutes.mainShell: (_) => const MainShell(),
          AppRoutes.routePlanner: (_) => const RoutePlannerScreen(),
          AppRoutes.safetyMap: (_) => const SafetyMapScreen(),
          AppRoutes.guardianCircle: (_) => const GuardianCircleScreen(),
          AppRoutes.sos: (_) => const SOSScreen(),
          AppRoutes.safetyCheckin: (_) => const SafetyCheckinScreen(),
          AppRoutes.incidentReport: (_) => const IncidentReportScreen(),
          AppRoutes.editProfile: (_) => const EditProfileScreen(),
          AppRoutes.safetyPreferences: (_) => const SafetyPreferencesScreen(),
          AppRoutes.notifications: (_) => const NotificationsScreen(),
          AppRoutes.tripHistory: (_) => const TripHistoryScreen(),
          AppRoutes.helpSupport: (_) => const HelpSupportScreen(),
          AppRoutes.about: (_) => const AboutScreen(),
          AppRoutes.aiAssistant: (_) => const AIAssistantScreen(),
        },
      ),
    );
  }
}
