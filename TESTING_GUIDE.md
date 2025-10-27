# Reflectify - Complete Testing Guide

## 🚀 Quick Start

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Android Emulator or Physical Device

### Run the App
```bash
cd /Users/kaivalyajoglekar/Desktop/Projects/MAD_Project/reflectify
flutter clean
flutter pub get
flutter run
```

---

## 📱 App Flow & Features to Test

### 1. **Splash Screen** (5 seconds)
**What to See:**
- ✅ Background image (bg_mad.jpg)
- ✅ Visible dotted grid overlay
- ✅ 3 animated merging blobs (pink, purple, teal)
- ✅ "REFLECTIFY" branding at bottom
- ✅ Loading spinner
- ✅ Auto-transition to Login after 5s

**How to Test:**
1. Launch app
2. Watch animations
3. Wait 5 seconds → should navigate to Login

**Expected:** Smooth animations, visible grid dots, professional look

---

### 2. **Login Screen**
**What to See:**
- ✅ Topographic white header with wave clip
- ✅ Email field (pre-filled: demo@email.com)
- ✅ Password field
- ✅ "Remember Me" checkbox
- ✅ "Forgot Password?" button
- ✅ Blue "Login" button
- ✅ "Sign up" link

**How to Test:**
1. Click "Login" button → Navigate to Main Navigation

**Expected:** Transitions to main app with sample user data

---

### 3. **Main Navigation Screen** (Hub)
**Navigation:**
- ✅ Bottom Navigation Bar (6 tabs)
- ✅ Drawer Menu (side menu)
- ✅ Floating Action Button (FAB)

#### **Bottom Navigation Tabs:**
| Tab # | Name | Icon | Screen |
|-------|------|------|--------|
| 0 | Dashboard | 🏠 | Enhanced Dashboard |
| 1 | Tasks | ✓ | Task Management |
| 2 | Calendar | 📅 | Enhanced Calendar |
| 3 | Projects | 📋 | Project Board |
| 4 | Focus | ⏱️ | Focus Mode |
| 5 | Journal | 📖 | Journal Timeline |

**How to Test:**
1. Tap each bottom tab
2. Verify screen changes
3. Check FAB changes based on tab

**Expected:** Smooth tab switching, correct screens load

---

## 🧪 Feature-by-Feature Testing

### **Feature 1: Dashboard** (Tab 0)

**What to See:**
- ✅ Date display (October 15, 2025+)
- ✅ Daily motivational quote
- ✅ Top 3 priorities section
- ✅ Upcoming deadlines
- ✅ Quick action buttons

**How to Test:**
1. Go to Dashboard tab
2. Check date is October 15, 2025 or later
3. Read daily quote
4. Scroll to see all sections

**Expected:** Clean dashboard layout, quote changes daily

---

### **Feature 2: Task Management** (Tab 1)

**What to See:**
- ✅ Category filter (All, Work, Personal, Projects, Study, Health)
- ✅ Task list with categories
- ✅ Priority indicators (High/Medium/Low)
- ✅ Swipe actions (Edit/Delete)
- ✅ Checkbox to complete tasks

**How to Test:**

#### **Add Task:**
1. Tap FAB (+) button
2. Dialog appears
3. Fill in:
   - Title: "Test Task"
   - Description: "Testing tasks"
   - Category: "Work"
   - Priority: "High"
   - Date & Time
4. Tap "Add Task"

**Expected:** Task appears in list with correct category color

#### **Edit Task:**
1. Swipe task to the right
2. Tap "Edit" icon
3. Modify details
4. Save changes

**Expected:** Changes reflect immediately

#### **Delete Task:**
1. Swipe task to the left
2. Tap "Delete" icon
3. Confirm deletion

**Expected:** Task removed from list

#### **Complete Task:**
1. Tap checkbox on task
2. Task marked complete

**Expected:** Task shows strikethrough or completion state

#### **Filter by Category:**
1. Tap category chips at top
2. List filters

**Expected:** Only tasks in selected category show

---

### **Feature 3: Calendar View** (Tab 2)

**What to See:**
- ✅ Monthly calendar
- ✅ Task markers on dates
- ✅ Color-coded by category
- ✅ Selected date details

**How to Test:**
1. Go to Calendar tab
2. Tap different dates
3. See tasks for that date below
4. Swipe left/right to change months

**Expected:** Tasks appear on correct dates with colors

---

### **Feature 4: Project Boards (Kanban)** (Tab 3)

**What to See:**
- ✅ 3 columns: To-Do, Doing, Done
- ✅ Project cards with progress
- ✅ Drag-and-drop support (upcoming)

**How to Test:**

#### **Add Project:**
1. Tap FAB (+)
2. Fill project details
3. Add tasks to project
4. Choose column status

**Expected:** Project card appears in selected column

#### **View Project:**
1. Tap project card
2. See tasks and details

**Expected:** Project details displayed

---

### **Feature 5: Focus Mode / Pomodoro** (Tab 4)

**What to See:**
- ✅ Timer options (15, 25, 45, 60 min)
- ✅ Circular progress indicator
- ✅ Start/Pause/Stop controls
- ✅ Ambient sound selector
- ✅ Session stats

**How to Test:**

#### **Start Focus Session:**
1. Select duration (e.g., 25 min)
2. Choose sound (e.g., Rain)
3. Tap "Start" button
4. Timer counts down

**Expected:** Circular progress animates, timer counts down

#### **Pause Session:**
1. Tap "Pause" button

**Expected:** Timer pauses

#### **Stop Session:**
1. Tap "Stop" button
2. Session ends

**Expected:** Stats update (total sessions, focus hours)

#### **Ambient Sounds:**
1. Toggle between: None, Rain, Ocean, Forest, Cafe

**Expected:** Sound indicator shows selected option

---

### **Feature 6: Journal Timeline** (Tab 5)

**What to See:**
- ✅ Chronological timeline
- ✅ Monthly grouping
- ✅ Mood indicators
- ✅ Entry previews
- ✅ Search/filter

**How to Test:**

#### **Add Journal Entry:**
1. Tap FAB (+)
2. Fill in:
   - Title: "My Day"
   - Content: "Today was amazing..."
   - Mood: Happy 😊
   - Tags: work, personal
   - Milestone: (optional)
3. Tap "Save"

**Expected:** Entry appears in timeline

#### **View Entry:**
1. Tap entry card
2. Full content displays

**Expected:** Can read full journal entry

#### **Edit Entry:**
1. Tap entry
2. Tap "Edit" button
3. Modify content
4. Save

**Expected:** Changes saved

#### **Filter by Mood:**
1. Tap mood filter chips
2. Timeline filters

**Expected:** Only entries with selected mood show

#### **Search Entries:**
1. Tap search icon
2. Type keywords
3. Results filter

**Expected:** Matching entries appear

---

### **Feature 7: Daily Summary** (Drawer Menu)

**What to See:**
- ✅ Today's completion stats
- ✅ Weekly progress chart
- ✅ Task breakdown by category
- ✅ Productivity insights

**How to Test:**
1. Open drawer menu
2. Tap "Daily Summary"
3. View stats and charts

**Expected:** Charts display correctly, stats accurate

---

### **Feature 8: Notifications & Reminders**

**What to See:**
- ✅ Task reminders
- ✅ Daily affirmations
- ✅ Notification badges

**How to Test:**

#### **Set Reminder:**
1. Create task
2. Enable "Reminder"
3. Set time
4. Save

**Expected:** Notification appears at scheduled time

**Note:** Test on physical device for best results

---

## 🔧 Drawer Menu Features

### **How to Open Drawer:**
- Swipe from left edge
- OR tap hamburger menu icon (☰)

### **Drawer Options:**
| Option | Action |
|--------|--------|
| 📊 Dashboard | Go to dashboard |
| ✓ Tasks | Go to task management |
| 📅 Calendar | Go to calendar view |
| 📋 Projects | Go to project boards |
| ⏱️ Focus Mode | Go to focus timer |
| 📖 Journal | Go to journal timeline |
| 📈 Daily Summary | View analytics |
| ⚙️ Settings | App settings |
| 👤 Profile | User profile |

**How to Test:**
1. Open drawer
2. Tap each option
3. Verify navigation

**Expected:** Correct screen opens

---

## 🎯 FAB (Floating Action Button) Testing

**Context-Aware Actions:**

| Current Tab | FAB Icon | Action |
|-------------|----------|--------|
| Dashboard | + | Add Task |
| Tasks | + | Add Task |
| Calendar | + | Add Task/Event |
| Projects | + | Add Project |
| Focus | ⏱️ | Start Session |
| Journal | + | Add Entry |

**How to Test:**
1. Switch between tabs
2. Note FAB icon changes
3. Tap FAB
4. Correct dialog appears

**Expected:** FAB adapts to context

---

## 📝 Common Testing Scenarios

### **Scenario 1: Daily Workflow**
1. Open app (Splash → Login)
2. Login
3. Check Dashboard
4. Add 3 tasks for today
5. Start Focus session (25 min)
6. Mark task complete
7. Write journal entry
8. Check Daily Summary

**Expected:** Smooth workflow, all features work

---

### **Scenario 2: Week Planning**
1. Go to Calendar
2. Add tasks for next 7 days
3. Set priorities
4. Set reminders
5. Create project for big goal
6. Add tasks to project

**Expected:** Tasks show on calendar, reminders set

---

### **Scenario 3: Productivity Tracking**
1. Complete 5 tasks
2. Do 2 focus sessions
3. Write 1 journal entry
4. Check Daily Summary
5. View weekly charts

**Expected:** Stats accurate, charts display

---

## 🐛 Known Issues & Workarounds

### **Issue 1: Drag-and-Drop in Kanban**
**Status:** Stubbed out (future implementation)
**Workaround:** Manually change project status via edit dialog

### **Issue 2: Google Calendar Sync**
**Status:** Not implemented
**Workaround:** Manual entry only

### **Issue 3: Background Notifications**
**Status:** Requires platform permissions
**Workaround:** Ensure notifications enabled in device settings

---

## 🧪 Quick Test Checklist

### **Basic Functionality:**
- [ ] App launches without crashes
- [ ] Splash screen displays correctly
- [ ] Login works
- [ ] All tabs accessible
- [ ] Drawer menu opens
- [ ] FAB creates items

### **Task Features:**
- [ ] Can add task
- [ ] Can edit task
- [ ] Can delete task
- [ ] Can complete task
- [ ] Can filter by category
- [ ] Swipe actions work

### **Journal Features:**
- [ ] Can add entry
- [ ] Can edit entry
- [ ] Mood selection works
- [ ] Tags save correctly
- [ ] Timeline displays

### **Focus Features:**
- [ ] Timer starts
- [ ] Timer pauses
- [ ] Timer stops
- [ ] Progress animates
- [ ] Stats update

### **Calendar Features:**
- [ ] Tasks show on dates
- [ ] Can select dates
- [ ] Can navigate months
- [ ] Colors match categories

### **Projects:**
- [ ] Can create project
- [ ] Can add tasks to project
- [ ] Columns display (To-Do, Doing, Done)
- [ ] Progress shows

---

## 📊 Performance Testing

### **Check For:**
- ✅ Smooth animations (60 FPS)
- ✅ No lag when scrolling
- ✅ Quick screen transitions
- ✅ Memory usage acceptable
- ✅ Battery usage normal

### **How to Monitor:**
```bash
# Check performance
flutter run --profile

# Check memory
flutter run --trace-startup
```

---

## 🔍 Debugging Tips

### **Enable Debug Mode:**
```dart
// In main.dart
debugShowCheckedModeBanner: false, // Already disabled
```

### **Check Console Logs:**
- Look for errors in terminal
- Check for null pointer exceptions
- Verify network calls (if any)

### **Hot Reload:**
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

---

## 📱 Platform-Specific Testing

### **Android:**
```bash
flutter run -d <android-device-id>
```

### **iOS:**
```bash
cd ios
pod install
cd ..
flutter run -d <ios-device-id>
```

### **Web:**
```bash
flutter run -d chrome
```

---

## ✅ Final Verification

Before considering testing complete:

1. **All 10 Features Tested:**
   - [ ] Daily Planner Dashboard
   - [ ] Task Management
   - [ ] Notes & Journaling
   - [ ] Calendar View
   - [ ] Reminders & Notifications
   - [ ] Focus Mode / Pomodoro
   - [ ] Daily Summary & Insights
   - [ ] Project Boards
   - [ ] Journal Timeline
   - [ ] Daily Affirmations

2. **Navigation Tested:**
   - [ ] Bottom nav works
   - [ ] Drawer menu works
   - [ ] FAB adapts to context
   - [ ] Back button works

3. **Data Persistence:**
   - [ ] Tasks saved
   - [ ] Journal entries saved
   - [ ] Projects saved
   - [ ] Settings saved

4. **UI/UX:**
   - [ ] Glassmorphism effects
   - [ ] Gradients display
   - [ ] Animations smooth
   - [ ] Responsive layout

---

## 🎓 Sample Test Data

### **Sample Tasks:**
```
1. "Review project proposal" - Work - High - Today 10:00 AM
2. "Gym session" - Health - Medium - Today 6:00 PM
3. "Read chapter 5" - Study - Low - Tomorrow
4. "Team meeting" - Work - High - Oct 16, 9:00 AM
5. "Grocery shopping" - Personal - Medium - Oct 17
```

### **Sample Journal Entries:**
```
1. Title: "First Day Success"
   Mood: Happy
   Tags: work, achievement
   Content: "Had a productive day..."

2. Title: "Reflection on Goals"
   Mood: Neutral
   Tags: personal, planning
   Content: "Thinking about next steps..."
```

### **Sample Projects:**
```
1. "Website Redesign" - Work
   Tasks: 3 total (1 done, 1 doing, 1 todo)

2. "Fitness Challenge" - Health
   Tasks: 5 total (0 done, 2 doing, 3 todo)
```

---

## 🚀 Next Steps After Testing

1. **Report Issues:** Note any bugs found
2. **Suggest Improvements:** UX enhancements
3. **Performance Tuning:** Optimize slow areas
4. **Add Features:** Based on feedback

---

## 📞 Support

If you encounter issues:
1. Check console for errors
2. Run `flutter doctor`
3. Clean and rebuild
4. Check this guide for solutions

---

**Happy Testing! 🎉**

---

**Last Updated:** October 27, 2025  
**App Version:** 1.0.0  
**Flutter Version:** Latest Stable
