Customizable Fitness Tracker
Overview
Customizable Fitness Tracker is a Flutter mobile application designed to help users set, track, and achieve their weekly or monthly workout goals. Users can set a workout goal (e.g., 5 workouts per week), update their progress incrementally, and monitor progress visually through a clean, intuitive UI with progress bars and motivational feedback.

Key features include:

Set and save workout goals with preferred frequency (weekly/monthly).

Update progress incrementally via a user-friendly dialog input.

View real-time progress against goals with animated progress bars.

Reset progress and goals easily.

Persistent storage of data using SharedPreferences for seamless user experience across sessions.

Motivational feedback with celebratory animations upon achieving goals.

How to Run
Prerequisites:

Flutter SDK installed (version 3.0 or higher recommended).

Compatible device or emulator set up for Android/iOS.

Clone the repository:

bash
Copy
Edit
git clone https://github.com/Aswinraj040/customizable_fitness_tracker.git
cd customizable_fitness_tracker
Get dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

On a connected device/emulator:

bash
Copy
Edit
flutter run
Or launch from your IDE (VS Code, Android Studio).

Trade-offs and Limitations
Local Storage Only: The app currently uses SharedPreferences for local persistence. This is simple but not suitable for syncing data across devices or users.

No Authentication: There is no user account system; data is device-specific and can be lost if the app is uninstalled.

UI Complexity: The UI is simple and effective but lacks advanced customization or accessibility features.

Limited Goal Types: Supports only numeric workout goals. Other goal types (e.g., duration, calories) are not implemented.

No Backend: No cloud backend for storing or analyzing data, limiting multi-device use and advanced analytics.

What I'd Improve With More Time
Cloud Sync & Authentication: Implement user authentication and cloud storage (e.g., Firebase) for cross-device syncing and backup.

More Goal Types & Analytics: Add support for different goal metrics (e.g., calories burned, workout duration) and detailed progress analytics/charts.

Custom Notifications & Reminders: Integrate push notifications or local reminders to motivate users to meet their goals.

Improved UI/UX: Add accessibility features, theming options, and more engaging animations.

Workout Logging: Extend the app to allow logging individual workouts with notes, types, and detailed stats.

Social Sharing: Enable users to share progress or achievements on social platforms for motivation.

![WhatsApp Image 2025-06-08 at 23 20 17](https://github.com/user-attachments/assets/029b13ad-ecd7-4fac-b774-60205e301d24)
![WhatsApp Image 2025-06-08 at 23 20 18](https://github.com/user-attachments/assets/45c79965-37c0-4e48-93cf-e75f6b3b79dd)
![WhatsApp Image 2025-06-08 at 23 20 55](https://github.com/user-attachments/assets/9a69b3fd-5699-4260-af90-1f4ec16782ec)
![WhatsApp Image 2025-06-08 at 23 20 17 (1)](https://github.com/user-attachments/assets/f4ea7e99-973e-4d5a-9f90-5dd079eaac3e)
![WhatsApp Image 2025-06-08 at 23 20 54](https://github.com/user-attachments/assets/1baed6bb-9adb-4365-8669-5152938f320a)
![WhatsApp Image 2025-06-08 at 23 20 17 (2)](https://github.com/user-attachments/assets/497fda80-733c-4f10-923b-ffd5e3502d53)
