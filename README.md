# Momento (Reflectify) ✨

<div align="center">

**Reflect. Focus. Achieve.**

A comprehensive productivity and self-reflection app that combines task management, focus sessions, journaling, and analytics - all with real-time Firebase sync.

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

</div>

---

## 🌟 Overview

Momento (Reflectify) is a modern all-in-one productivity companion that helps you organize your day, stay focused, reflect on your journey, and track your progress. Built with Flutter and featuring a stunning glassmorphism UI with animated aurora backgrounds, Momento makes productivity beautiful while keeping your data safe with Firebase Realtime Database.

## ✨ Key Features

### � **Firebase Integration**
- **Real-time Data Sync**: All tasks and journals automatically synced to Firebase
- **User Isolation**: Each user's data stored securely under their unique UID
- **Offline Support**: Data cached locally and synced when online
- **Secure Authentication**: Firebase Auth with email/password
- **Data Structure**: 
  ```
  users/
    <user_uid>/
      tasks/
        <task_id>: { title, date, priority, ... }
      journals/
        <journal_id>: { title, content, mood, ... }
  ```

### 📊 **Enhanced Dashboard**
- **Personalized Greeting**: Dynamic greetings based on time of day with user initial avatar
- **Today's Overview**: Header card showing current date with clickable task count badge
  - **Interactive Task Badge**: Click the circular badge to view all tasks for today
  - **Task Count Display**: Shows total number of tasks scheduled
  - **Modal View**: Beautiful dialog showing all today's tasks with:
    - Complete/incomplete checkbox toggles
    - Time, category, and priority badges
    - Task title and details
    - Color-coded borders based on category
    - Close button for easy dismissal
- **Quick Actions**: Fast access to Journal, Calendar, and Focus Mode
- **Top 3 Priorities**: Intelligent priority-based task display with color-coded badges
- **Upcoming Deadlines**: Visual deadline tracking with days remaining
  - **Smart Countdown**: Shows "Today", "Tomorrow", or "Xd" format
  - **Color-coded Urgency**: 
    - 🔴 Red: Overdue tasks ("Xd ago")
    - 🟠 Orange: Urgent (≤3 days remaining)
    - 🔵 Blue: Coming up (>3 days remaining)
  - **Priority Fallback**: Shows HIGH/MED/LOW badge if no deadline exists
  - **Visual Icons**: Error, timer, or calendar icons based on urgency
- **Progress Overview**: Real-time completion tracking with animated progress bars
- **Streak Counter**: Fire icon showing your current productivity streak
- **Recent Journal**: Quick access to your latest journal entries

### ✅ **Advanced Task Management**
- **Firebase-Synced Tasks**: Create, edit, delete tasks with instant Firebase sync
- **Smart Calendar View**: TableCalendar integration with priority indicators
- **24-Hour Timeline**: Hourly breakdown of your daily schedule
- **Priority System**: 3-tier priority levels (High/Medium/Low) with color coding
- **Category Organization**: Work, Personal, Projects, Study, Health
- **Rich Task Details**: 
  - Title and description
  - Start date and end date (deadline) pickers
  - Start time and end time with AM/PM picker
  - Time validation (end time must be after start time)
  - Date validation (end date must be on or after start date)
  - Category and priority assignment
  - UUID-based task IDs for Firebase compatibility
- **Deadline Management**:
  - Tasks appear on both start date and end date in calendar/timeline
  - Deadline badge shown on timeline cards (orange badge with "MMM d" format)
  - Automatic deadline calculation from end date + end time
  - Days until deadline displayed in Upcoming Deadlines section
- **Task Actions**: 
  - Complete/incomplete toggle (synced to Firebase)
  - Edit with pre-filled form maintaining all data
  - Delete with confirmation
  - All changes immediately reflected in Firebase
- **Visual Feedback**: 
  - Color-coded priority indicators on calendar dates
  - Custom toast notifications for all actions
  - Loading states during Firebase operations
  - Green border for completed tasks
  - Deadline badges on timeline task cards

### 🎯 **Focus Mode**
- **Pomodoro Timer**: Customizable focus sessions (15m, 25m, 45m, 1h)
- **Custom Duration**: Set your own focus duration
- **Session Tracking**: 
  - Start time and end time recording
  - Completion status tracking
  - Session history with timestamps
- **Visual Timer**: Large circular timer with countdown display
- **Session History**: View all past focus sessions with completion status
- **Tab Interface**: Switch between Timer and History views
- **Beautiful UI**: Aurora background effects during focus sessions

### 📝 **Journal Timeline with Firebase**
- **Cloud-Synced Journals**: All entries automatically saved to Firebase
- **Rich Text Entries**: Write detailed journal entries with timestamps
- **Mood Tracking**: Track emotional state (happy, sad, neutral, excited, etc.)
- **Favorites System**: 
  - Mark important entries (synced to Firebase)
  - Toggle favorite status with star icon
  - Filter to show only favorites
- **Calendar Integration**: Visual calendar showing days with journal entries
- **Timeline View**: Month-grouped chronological display
- **Filter Options**: 
  - All entries
  - Favorites only
  - Recent entries (last 20)
- **Entry Management**:
  - Create new entries with mood selector
  - Edit existing entries (coming soon)
  - Delete with confirmation (synced to Firebase)
  - Date and time stamps
  - Full content display

### 📈 **Analytics & Profile**
- **Comprehensive Stats**:
  - Total journal entries count (from Firebase)
  - Tasks completed counter (from Firebase)
  - Longest streak calculator
  - Member since date (from Firebase Auth)
  - User email from authenticated account
- **Interactive Charts**:
  - Weekly view: 7-day line chart of completed tasks
  - Daily view: Task completion rate and progress
  - Date navigation with picker
  - Toggle between weekly and daily views
  - **Fixed Y-axis**: Displays whole numbers (0, 1, 2, 3...) with proper intervals
  - **Zero-value handling**: Shows default scale when no data exists
- **Visual Insights**: 
  - Color-coded charts with theme integration
  - Smooth animations and transitions
  - Real-time data updates from Firebase
  - Clean axis labels with proper spacing
- **User Profile**:
  - Avatar with user initial (from email)
  - Username from email
  - Display name and email
  - Logout with confirmation dialog

### 🎨 **Modern UI/UX**
- **Splash Screen**:
  - Circular Momento logo with aurora glow effects
  - Animated gradient "MOMENTO" text with fade and scale effect
  - Fast reveal animation (300ms) - starts at 1.0s, completes at 1.3s
  - Black background (no white flash)
  - Smooth 5-second total duration
  - Auto-navigation based on Firebase auth state
  - Purple and cyan glow shadows on text
  - Animated auroras in background (subtle motion)
- **App Icon**: 
  - Custom circular Momento logo
  - 25% adaptive padding to prevent cutoff on various devices
  - Black background with centered logo
  - Generated via flutter_launcher_icons
- **Glassmorphism Design**: Frosted glass effects throughout
- **Animated Aurora Background**: Smooth 40-second gradient animations
- **Liquid Navigation Bar**: 
  - Animated glass indicator that slides between tabs
  - White ripple effects on tap
  - 4-tab layout: Dashboard, Tasks, Focus, Journal
  - Profile accessible from dashboard avatar
- **Gradient FAB**: Context-aware floating action button
- **Glass Cards**: Consistent design across all screens
- **Color Theming**: 
  - Purple primary color (#8A5DF4)
  - Color-coded categories and priorities
  - Dark mode optimized (light mode completely removed)
- **Smooth Animations**:
  - 300ms tab transitions
  - Scale animations on selection
  - Fade and slide effects
  - Elastic bounce on text reveal

### 🔐 **Authentication & Security**
- **Firebase Authentication**: 
  - Email/password login and signup
  - Secure session management
  - Password reset functionality
- **User Management**: 
  - Profile data stored in Firebase
  - User-specific data isolation
  - Automatic UID-based data organization
- **Session Persistence**: Stay logged in across app restarts
- **Logout Confirmation**: Prevent accidental logouts with dialog
- **Security Rules**: Firebase rules ensure users only access their own data

### 🎯 **Smart Features**
- **Real-time Sync**: All data changes instantly synced to Firebase
- **Error Handling**: User-friendly error messages for Firebase operations
- **RepaintBoundary Optimization**: Isolated screen repaints
- **Const Constructors**: Memory-efficient widget building
- **Riverpod State Management**: Theme mode and app state
- **Custom Toast Notifications**: Beautiful feedback for all actions
- **Empty State Handling**: Helpful messages when no data exists
- **Input Validation**: 
  - Time validation (end time after start time)
  - Required field checks
  - Date range constraints
  - Firebase-safe ID generation (UUID)

## 🛠️ Tech Stack

### **Framework & Language**
- **Flutter 3.9+**: Cross-platform UI framework
- **Dart 3.0+**: Programming language
- **Material Design 3**: Modern design system

### **Backend & Database**
- **Firebase Authentication**: User authentication and management
- **Firebase Realtime Database**: Real-time data storage and sync
- **Firebase Security Rules**: User-specific data isolation

### **State Management**
- **Riverpod 3.0+**: Modern state management

### **UI Packages**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase (ACTIVE)
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  firebase_database: ^12.0.3
  
  # State Management
  flutter_riverpod: ^3.0.3
  riverpod: ^3.0.3
  provider: ^6.1.5+1
  
  # UI Components
  table_calendar: ^3.2.0         # Calendar widget
  fl_chart: ^1.1.1              # Analytics charts
  glass_kit: ^4.0.2             # Glassmorphism effects
  flutter_slidable: ^4.0.3      # Swipe actions
  percent_indicator: ^4.2.3     # Progress indicators
  
  # Utilities
  intl: ^0.20.2                 # Date/time formatting
  uuid: ^4.5.1                  # Firebase-safe UUID generation
  shared_preferences: ^2.3.4    # Local storage
  
  # Notifications & Location
  flutter_local_notifications: ^19.5.0
  geolocator: ^14.0.2
  timezone: ^0.10.1
  
  # Media
  image_picker: ^1.2.0
  
  # Info
  package_info_plus: ^8.3.1
  
  # Other
  http: ^1.2.2
  markdown: ^7.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.13.1  # App icon generation
```

## � Project Structure

```
lib/
├── main.dart                          # Entry point with Firebase init
├── firebase_options.dart              # Firebase configuration
├── models/
│   ├── task_model.dart               # Task model with Firebase serialization + deadline
│   ├── journal_entry.dart            # Journal model with toJson/fromJson
│   ├── user_model.dart               # User model
│   ├── project_model.dart            # Project model
│   └── focus_session.dart            # Focus session model
├── screens/
│   ├── splash_screen.dart            # Momento logo + aurora splash (5s, fast text)
│   ├── login_screen.dart             # Firebase Auth login
│   ├── signup_screen.dart            # Firebase Auth signup
│   ├── main_navigation_screen.dart   # Nav wrapper + Firebase CRUD + task dialog
│   ├── enhanced_dashboard_screen.dart # Dashboard with clickable task badge + deadlines
│   ├── enhanced_calendar_screen.dart  # Calendar + 24h timeline with deadline badges
│   ├── focus_mode_screen.dart        # Pomodoro timer with history
│   ├── journal_timeline_screen.dart  # Firebase-synced journals with favorites
│   └── full_profile_screen.dart      # Analytics charts with fixed Y-axis
├── widgets/
│   ├── app_background.dart           # 40-second gradient aurora animations
│   ├── glass_card.dart              # Glassmorphism card widget
│   ├── custom_bottom_navbar.dart    # 4-tab animated navigation bar
│   └── custom_toast.dart            # Beautiful toast notifications
├── utils/
│   └── streak_calculator.dart       # Productivity streak calculations
└── providers/
    └── theme_provider.dart          # Dark theme only (light mode removed)

assets/
└── momento_logo.jpg                  # App branding logo (circular)
└── grid.jpg                          # Background grid for splash

android/
├── app/
│   ├── google-services.json          # Firebase Android config
│   └── src/main/res/
│       ├── values/
│       │   └── styles.xml            # Black splash theme (Theme.Black)
│       └── drawable/
│           └── launch_background.xml # Black splash with centered logo

ios/
└── Runner/
    └── GoogleService-Info.plist      # Firebase iOS config
```

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK 3.9+**: [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart SDK 3.0+**: Comes with Flutter
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**: For version control
- **Firebase Account**: [Create one here](https://firebase.google.com)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/reflectify.git
   cd reflectify
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup** (REQUIRED)

   a. **Create a Firebase Project**:
      - Go to [Firebase Console](https://console.firebase.google.com)
      - Click "Add project" and follow the wizard
      - Enable Google Analytics (optional)

   b. **Enable Firebase Authentication**:
      - In Firebase Console, go to **Authentication**
      - Click "Get Started"
      - Enable **Email/Password** sign-in method
      - Click "Save"

   c. **Enable Firebase Realtime Database**:
      - In Firebase Console, go to **Realtime Database**
      - Click "Create Database"
      - Choose a database location (e.g., `us-central1`)
      - Start in **test mode** (for now)
      - Click "Enable"

   d. **Set Security Rules**:
      - In Realtime Database, go to **Rules** tab
      - Replace the rules with:
      ```json
      {
        "rules": {
          "users": {
            "$uid": {
              ".read": "$uid === auth.uid",
              ".write": "$uid === auth.uid"
            }
          }
        }
      }
      ```
      - Click "Publish"

   e. **Add Firebase to Flutter**:
      
      **For Android**:
      - In Firebase Console, click the Android icon
      - Register app with package name: `com.example.reflectify` (or your package name)
      - Download `google-services.json`
      - Place it in `android/app/` directory
      - Firebase will auto-configure your `build.gradle` files

      **For iOS**:
      - In Firebase Console, click the iOS icon
      - Register app with bundle ID from `ios/Runner.xcodeproj`
      - Download `GoogleService-Info.plist`
      - Place it in `ios/Runner/` directory using Xcode

   f. **Configure FlutterFire CLI** (Easiest Method):
      ```bash
      # Install FlutterFire CLI
      dart pub global activate flutterfire_cli

      # Configure Firebase for your project
      flutterfire configure

      # Select your Firebase project
      # Choose platforms (Android, iOS, macOS, etc.)
      # This will generate firebase_options.dart automatically
      ```

4. **Verify Firebase Configuration**
   - Check that `firebase_options.dart` exists in `lib/`
   - Verify `google-services.json` exists in `android/app/`
   - Verify `GoogleService-Info.plist` exists in `ios/Runner/`

5. **Run the app**
   ```bash
   # Connect a device or start an emulator, then:
   flutter run

   # Or specify a device
   flutter run -d chrome      # Web
   flutter run -d android     # Android
   flutter run -d ios         # iOS (macOS only)
   ```

### First Launch

1. **Splash Screen**: 5-second animated Momento logo
2. **Sign Up**: Create an account with email/password
3. **Login**: Sign in to access your dashboard
4. **Add Your First Task**: Tap the "+" FAB on Dashboard or Tasks tab
5. **Start a Focus Session**: Navigate to Focus tab and choose duration
6. **Write a Journal Entry**: Go to Journal tab and record your thoughts
7. **Check Analytics**: View your stats in the Profile section

### Troubleshooting

**Firebase Connection Issues**:
```bash
# Clear Flutter cache
flutter clean
flutter pub get

# Rebuild the app
flutter run
```

**Database Permission Denied**:
- Verify Firebase security rules are set correctly
- Ensure user is logged in (check Firebase Auth console)
- Check Firebase Console > Realtime Database > Data tab for user structure

**Build Errors**:
```bash
# Update dependencies
flutter pub upgrade

# Repair Flutter installation
flutter doctor
flutter doctor --android-licenses  # If needed
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📱 Screenshots

<!-- Add screenshots of your app here -->

## 🎨 Design Highlights

### Color Palette
- **Primary**: `#8A5DF4` (Purple)
- **Work**: `#8A5DF4` (Purple)
- **Personal**: `#D62F6D` (Pink)
- **Projects**: `#4ECDC4` (Teal)
- **Study**: `#F4A261` (Orange)
- **Health**: `#06D6A0` (Green)
- **High Priority**: `#FF5252` (Red)
- **Medium Priority**: `#FF9800` (Orange)
- **Low Priority**: `#4CAF50` (Green)

### Typography
- **Headings**: Bold, 20-24px
- **Body**: Regular/Medium, 14-16px
- **Labels**: Small, 11-12px
- **Font**: System default (San Francisco on iOS, Roboto on Android)

## 🔧 Configuration

### Firebase Realtime Database Structure

```json
{
  "users": {
    "<user_uid>": {
      "tasks": {
        "<task_uuid>": {
          "id": "550e8400-e29b-41d4-a716-446655440000",
          "title": "Complete project report",
          "description": "Finish the quarterly report",
          "date": "2024-01-15T00:00:00.000Z",
          "time": "9:00 AM - 10:30 AM",
          "startTime": "2024-01-15T09:00:00.000Z",
          "endTime": "2024-01-15T10:30:00.000Z",
          "deadline": "2024-01-15T17:00:00.000Z",
          "category": "Work",
          "priority": 1,
          "color": 4294198070,
          "isCompleted": false
        }
      },
      "journals": {
        "<journal_uuid>": {
          "id": "660e8400-e29b-41d4-a716-446655440001",
          "title": "Productive Monday",
          "content": "Started the week strong...",
          "date": "2024-01-15T08:00:00.000Z",
          "mood": "happy",
          "tags": ["productivity", "morning"],
          "isFavorite": true
        }
      }
    }
  }
}
```

### Firebase Security Rules

**Realtime Database Rules**:
```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

This ensures:
- Each user can only read/write their own data
- Data is isolated by user UID
- Authentication required for all operations

### Task Priority & Categories

**Priority Levels**:
- 🔴 **High (1)**: Red (`Colors.red`)
- 🟡 **Medium (2)**: Orange (`Colors.orange`)
- 🟢 **Low (3)**: Green (`Colors.green`)

**Priority Display**:
- Numbers stored in Firebase (1, 2, 3)
- Displayed as HIGH, MED, LOW in UI
- Color-coded badges throughout the app

**Categories**:
- 💼 **Work**: Blue (`Colors.blue`)
- 👤 **Personal**: Green (`Colors.green`)
- 📁 **Projects**: Purple (`Colors.purple`)
- 📚 **Study**: Orange (`Colors.orange`)
- ❤️ **Health**: Pink (`Colors.pink`)

### Mood Tracking Options

Available mood states for journal entries:
- 😊 **Happy** | 😔 **Sad** | 😐 **Neutral** | 🤩 **Excited**
- 😰 **Anxious** | 😌 **Calm** | 😫 **Tired** | 😡 **Angry**

### Focus Session Durations

Preset Pomodoro timers:
- ⏱️ **15 minutes**: Quick focus burst
- ⏱️ **25 minutes**: Classic Pomodoro
- ⏱️ **45 minutes**: Deep work session
- ⏱️ **60 minutes**: Extended focus
- ⚙️ **Custom**: Set your own duration

### App Icon & Splash

**App Icon**:
- Source: `assets/momento_logo.jpg`
- Size: 1024x1024 minimum
- Shape: Circular with black background
- Generated via `flutter_launcher_icons`

**Splash Screen**:
- Duration: 5 seconds
- Logo: Circular (120x120) with aurora glow
- Text: Gradient "MOMENTO" above loader
- Background: Black (#000000)
- Animation: Fade-in transitions

### Theme Mode
Toggle between light and dark mode (currently dark mode optimized):
```dart
// In providers/theme_provider.dart
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
```

### Animation Duration
Adjust background animation speed:
```dart
// In widgets/app_background.dart
duration: const Duration(seconds: 40), // Slower = better performance
```

### Bottom Navbar Height
```dart
// In screens/main_navigation_screen.dart
height: 70, // Navbar height
const EdgeInsets.fromLTRB(20, 20, 20, 120), // Screen bottom padding
```

## 🤝 Contributing

Contributions are what make the open-source community amazing! Any contributions are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Ideas
- [ ] Add task notifications with reminders
- [ ] Implement data export/import (JSON/CSV)
- [ ] Add more chart types in analytics (pie, bar charts)
- [ ] Create widget for home screen
- [ ] Implement task categories customization
- [ ] Add focus mode sound effects/music
- [ ] Create onboarding tutorial for new users
- [ ] Add task recurrence/repeat functionality
- [ ] Implement subtasks feature
- [ ] Add collaboration/sharing features
- [ ] Dark/light theme toggle in UI (currently dark only)
- [ ] Add tags system for better organization
- [ ] Implement search functionality
- [ ] Add task attachments support
- [ ] Create backup/restore functionality

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👨‍💻 Author

**Kaivalya Joglekar**

- GitHub: [@KaivalyaJoglekar](https://github.com/KaivalyaJoglekar)
- Project Link: [https://github.com/KaivalyaJoglekar/Reflectify](https://github.com/KaivalyaJoglekar/Reflectify)

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - Amazing cross-platform framework
- [Firebase](https://firebase.google.com) - Backend services
- [FL Chart](https://github.com/imaNNeo/fl_chart) - Beautiful charts
- [Table Calendar](https://pub.dev/packages/table_calendar) - Calendar widget
- [Riverpod](https://riverpod.dev) - State management
- Design inspiration from modern productivity apps

## 📞 Support

If you like this project, please ⭐ star the repository!

For issues and feature requests, please use the [GitHub Issues](https://github.com/KaivalyaJoglekar/Reflectify/issues) page.

---

<div align="center">

**Made with ❤️ and Flutter**

*Reflect. Focus. Achieve.*

</div>