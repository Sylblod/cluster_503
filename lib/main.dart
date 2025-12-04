import 'package:flutter/material.dart';
import 'screens/public/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/public/eventos_screen.dart';
import 'screens/admin/create_users_screen.dart';
import 'screens/admin/view_user_screen.dart';
import 'screens/admin/edit_users_screen.dart';
import 'screens/admin/create_events_screen.dart';
import 'screens/admin/view_events_screen.dart';
import 'screens/admin/edit_events_screen.dart';
import 'screens/admin/view_participants_screen.dart';
import 'screens/teachers/view_participants_screen.dart';



void main() {
  runApp(const AppCluster503());
}

class AppCluster503 extends StatelessWidget {
  const AppCluster503({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cluster 503 TKD',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFFFF9800),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PublicHomeScreen(),
        '/eventos': (context) => const EventosScreen(), 
        '/login': (context) => const LoginScreen(),
        //admin
        '/create_users_screen': (context) => const CreateUsersScreen(),
        '/view_user_screen': (context) => const ViewUserScreen(),
        '/edit_users_screen': (context) => const EditUsersScreen(),
        
        '/create_events_screen': (context) => const CreateEventsScreen(),
        '/view_events_screen': (context) => const ViewEventsScreen(),
        '/edit_events_screen': (context) => const EditEventsScreen(),
        '/view_user_screen_participants': (context) => const ViewUserScreenParticipants(),
        '/view_user_screen_participantsteacher': (context) => const ViewUserScreenParticipantsTeacher(),
        


      },
    );
  }
}