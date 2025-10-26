import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String _getEnv(String key) => dotenv.env[key]!;

  // Supabase Configuration
  static String get supabaseUrl => _getEnv('SUPABASE_URL');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY');

  // Google Sign In Configuration
  static String get googleAndroidClientId =>
      _getEnv('GOOGLE_ANDROID_CLIENT_ID');
  static String get googleWebClientId => _getEnv('GOOGLE_WEB_CLIENT_ID');

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
}
