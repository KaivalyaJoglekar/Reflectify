# Momento (Reflectify) ✨

\<div align="center"\>

**Reflect. Focus. Achieve.**

A comprehensive productivity and self-reflection app that combines task management, focus sessions, journaling, and analytics - all with real-time Firebase sync.

[](https://flutter.dev)
[](https://dart.dev)
[](https://firebase.google.com)

\</div\>

-----

## 🌟 Overview

Momento (Reflectify) is a modern all-in-one productivity companion that helps you organize your day, stay focused, reflect on your journey, and track your progress. Built with Flutter and featuring a stunning glassmorphism UI with animated aurora backgrounds, Momento makes productivity beautiful while keeping your data safe with Firebase Realtime Database.

## ✨ Key Features

### Firebase Integration

  * **Real-time Data Sync**: All tasks and journals automatically synced to Firebase
  * **User Isolation**: Each user's data stored securely under their unique UID
  * **Offline Support**: Data cached locally and synced when online
  * **Secure Authentication**: Firebase Auth with email/password
  * **Data Structure**:
    ```
    users/
      <user_uid>/
        tasks/
          <task_id>: { title, date, priority, ... }
        journals/
          <journal_id>: { title, content, mood, ... }
    ```

### 📊 Enhanced Dashboard

  * **Personalized Greeting**: Dynamic greetings based on time of day with user initial avatar
  * **Today's Overview**: Header card showing current date with clickable task count badge
      * **Interactive Task Badge**: Click the circular badge to view all tasks for today
      * **Task Count Display**: Shows total number of tasks scheduled
      * **Modal View**: Beautiful dialog showing all today's tasks
  * **Quick Actions**: Fast access to Journal, Calendar, and Focus Mode
  * **Top 3 Priorities**: Intelligent priority-based task display with color-coded badges
  * **Upcoming Deadlines**: Visual deadline tracking with days remaining
      * **Smart Countdown**: Shows "Today", "Tomorrow", or "Xd" format
      * **Color-coded Urgency**: Red (Overdue), Orange (≤3 days), Blue (\>3 days)
  * **Progress Overview**: Real-time completion tracking with animated progress bars
  * **Streak Counter**: Fire icon showing your current productivity streak
  * **Recent Journal**: Quick access to your latest journal entries

### ✅ Advanced Task Management

  * **Firebase-Synced Tasks**: Create, edit, delete tasks with instant Firebase sync
  * **Smart Calendar View**: TableCalendar integration with priority indicators
  * **24-Hour Timeline**: Hourly breakdown of your daily schedule
  * **Priority System**: 3-tier priority levels (High/Medium/Low) with color coding
  * **Category Organization**: Work, Personal, Projects, Study, Health
  * **Rich Task Details**: Title, description, start/end date & time pickers, category, and priority assignment
  * **Input Validation**: Time validation (end time must be after start time) and date validation (end date must be on or after start date)
  * **Deadline Management**: Tasks appear on both start and end dates; deadline badges shown on timeline cards
  * **Task Actions**: Complete/incomplete toggle, edit, and delete with confirmation, all synced to Firebase

### 🎯 Focus Mode

  * **Pomodoro Timer**: Customizable focus sessions (15m, 25m, 45m, 1h)
  * **Custom Duration**: Set your own focus duration
  * **Session Tracking**: Records start time, end time, and completion status
  * **Visual Timer**: Large circular timer with countdown display
  * **Session History**: View all past focus sessions with completion status
  * **Beautiful UI**: Aurora background effects during focus sessions

### 📝 Journal Timeline with Firebase

  * **Cloud-Synced Journals**: All entries automatically saved to Firebase
  * **Rich Text Entries**: Write detailed journal entries with timestamps
  * **Mood Tracking**: Track emotional state (happy, sad, neutral, excited, etc.)
  * **Favorites System**: Mark important entries, toggle favorite status, and filter to show only favorites (synced to Firebase)
  * **Calendar Integration**: Visual calendar showing days with journal entries
  * **Timeline View**: Month-grouped chronological display
  * **Filter Options**: All entries, favorites only, recent entries (last 20)
  * **Entry Management**: Create, delete (with confirmation), and view full entries

### 📈 Analytics & Profile

  * **Comprehensive Stats**: Total journal entries, tasks completed, longest streak, and member since date (all from Firebase)
  * **Interactive Charts**:
      * Weekly view: 7-day line chart of completed tasks
      * Daily view: Task completion rate and progress
      * **Fixed Y-axis**: Displays whole numbers with proper intervals
  * **Visual Insights**: Color-coded charts with smooth animations and real-time data updates
  * **User Profile**: Avatar with user initial, username, email, and logout functionality

### 🎨 Modern UI/UX

  * **Splash Screen**: 5-second animated circular logo with aurora glow effects and gradient text
  * **App Icon**: Custom circular logo with 25% adaptive padding to prevent cutoff
  * **Glassmorphism Design**: Frosted glass effects throughout
  * **Animated Aurora Background**: Smooth 40-second gradient animations
  * **Liquid Navigation Bar**: 4-tab layout (Dashboard, Tasks, Focus, Journal) with an animated glass indicator
  * **Color Theming**: Purple primary color (\#8A5DF4) with dark mode optimization (light mode removed)
  * **Smooth Animations**: 300ms tab transitions, scale animations, and fade/slide effects

### 🔐 Authentication & Security

  * **Firebase Authentication**: Email/password login and signup, secure session management, and password reset functionality
  * **User Management**: Profile data stored in Firebase with user-specific data isolation
  * **Session Persistence**: Stay logged in across app restarts
  * **Security Rules**: Firebase rules ensure users only access their own data

-----

## 🛠️ Tech Stack

### Framework & Language

  * **Flutter 3.9+**
  * **Dart 3.0+**

### Backend & Database

  * **Firebase Authentication**
  * **Firebase Realtime Database**
  * **Firebase Security Rules**

### State Management

  * **Riverpod 3.0+**
  * **Provider**

### Key UI Packages

  * **table\_calendar**: Calendar widget
  * **fl\_chart**: Analytics charts
  * **glass\_kit**: Glassmorphism effects
  * **flutter\_slidable**: Swipe actions
  * **percent\_indicator**: Progress indicators

### Utilities

  * **intl**: Date/time formatting
  * **uuid**: Firebase-safe UUID generation
  * **shared\_preferences**: Local storage
  * **flutter\_local\_notifications**: Notifications

-----

## Project Structure

```
lib/
├── main.dart                          # Entry point with Firebase init
├── firebase_options.dart              # Firebase configuration
├── models/
│   ├── task_model.dart               # Task model with Firebase serialization
│   ├── journal_entry.dart            # Journal model with toJson/fromJson
│   ├── user_model.dart               # User model
│   └── focus_session.dart            # Focus session model
├── screens/
│   ├── splash_screen.dart            # Momento logo + aurora splash
│   ├── login_screen.dart             # Firebase Auth login
│   ├── signup_screen.dart            # Firebase Auth signup
│   ├── main_navigation_screen.dart   # Nav wrapper + Firebase CRUD
│   ├── enhanced_dashboard_screen.dart # Dashboard with clickable task badge
│   ├── enhanced_calendar_screen.dart  # Calendar + 24h timeline
│   ├── focus_mode_screen.dart        # Pomodoro timer with history
│   ├── journal_timeline_screen.dart  # Firebase-synced journals
│   └── full_profile_screen.dart      # Analytics charts with fixed Y-axis
├── widgets/
│   ├── app_background.dart           # 40-second gradient aurora animations
│   ├── glass_card.dart              # Glassmorphism card widget
│   ├── custom_bottom_navbar.dart    # 4-tab animated navigation bar
│   └── custom_toast.dart            # Beautiful toast notifications
├── utils/
│   └── streak_calculator.dart       # Productivity streak calculations
└── providers/
    └── theme_provider.dart          # Dark theme only
```

-----

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:

  * **Flutter SDK 3.9+**
  * **Dart SDK 3.0+**
  * **A Firebase Account**

### Installation

1.  **Clone the repository**

    ```bash
    git clone https://github.com/KaivalyaJoglekar/Reflectify.git
    cd Reflectify
    ```

2.  **Install dependencies**

    ```bash
    flutter pub get
    ```

3.  **Firebase Setup** (REQUIRED)

      * Follow the **FlutterFire CLI** instructions to configure your Firebase project
        ```bash
        dart pub global activate flutterfire_cli
        flutterfire configure
        ```
      * Ensure you have `firebase_options.dart` in `lib/`, `google-services.json` in `android/app/`, and `GoogleService-Info.plist` in `ios/Runner/`
      * **Enable Authentication**: In the Firebase Console, enable **Email/Password** sign-in
      * **Enable Realtime Database**: In the Firebase Console, create a Realtime Database and start in **test mode**
      * **Set Security Rules**: Update your Realtime Database rules to isolate user data:
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

4.  **Run the app**

    ```bash
    flutter run
    ```

-----

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
          "startTime": "2024-01-15T09:00:00.000Z",
          "endTime": "2024-01-15T10:30:00.000Z",
          "deadline": "2024-01-15T17:00:00.000Z",
          "category": "Work",
          "priority": 1,
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
          "isFavorite": true
        }
      }
    }
  }
}
```

### Task Priority & Categories

  * **Priority Levels**: 🔴 **High (1)**, 🟡 **Medium (2)**, 🟢 **Low (3)**
  * **Categories**: 💼 **Work**, 👤 **Personal**, 📁 **Projects**, 📚 **Study**, ❤️ **Health**

### Mood Tracking Options

😊 **Happy** | 😔 **Sad** | 😐 **Neutral** | 🤩 **Excited** | 😰 **Anxious** | 😌 **Calm** | 😫 **Tired** | 😡 **Angry**

-----

## 🤝 Contributing

Contributions are greatly appreciated. Please fork the project and open a pull request.

### Contribution Ideas

  * [ ] Add task notifications with reminders
  * [ ] Implement data export/import (JSON/CSV)
  * [ ] Add more chart types in analytics
  * [ ] Create a home screen widget
  * [ ] Add task recurrence/repeat functionality
  * [ ] Implement subtasks feature
  * [ ] Add tags system for better organization
  * [ ] Implement search functionality

## 📄 License

Distributed under the MIT License.

## 👨‍💻 Author

**Kaivalya Joglekar**

  * GitHub: [@KaivalyaJoglekar](https://github.com/KaivalyaJoglekar)
  * Project Link: [https://github.com/KaivalyaJoglekar/Reflectify](https://github.com/KaivalyaJoglekar/Reflectify)

-----

\<div align="center"\>

**Made with ❤️ and Flutter**

*Reflect. Focus. Achieve.*

\</div\>
