# 📚 Study Pilot

Study Pilot is a simple Flutter app designed to help users manage their learning progress on various topics and concepts. It allows tracking the mastery status of concepts within a topic and calculates progress dynamically.

---

## 🚀 Features

- Add topics and associated concepts.
- Track progress of each topic based on mastered concepts.
- Three statuses for concepts:
  - ✅ Mastered
  - ⏳ In Progress
  - 🔄 To Review
- Light & dark mode support.

---

##  Tech Stack

###  **Frontend**
- **Flutter**: UI toolkit for building natively compiled apps.
- **Dart**: Programming language used with Flutter.
- **Material Design**: For consistent, beautiful UI across platforms.
- **Provider / setState**: (assumed) for UI state handling.

###  **Core Logic & Models**
- **Custom Models**:
  - `Concept`: Represents a unit of learning with title, description, resources, and status.
  - `Topic`: Represents a group of concepts and calculates progress dynamically.
- **Enum**:
  - `ConceptStatus`: Defines the status of each concept (`mastered`, `inProgress`, `toReview`).

###  **Testing**
- **Flutter Test**: Used for widget and logic testing.

###  **Mock Data**
- Hardcoded mock data to simulate user topics and concepts.

### **Themes**
- Flutter's built-in **light and dark theme** support using `ThemeData`.

---

## Installation & Running

### Prerequisites
- Flutter SDK installed
- Dart enabled
- Android Studio or VSCode (with Flutter plugin)

### Steps
```bash
git clone https://github.com/your-username/study_pilot.git
cd study_pilot
flutter pub get
flutter run

