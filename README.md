# Healing Bloom -  Skin Disease Identification App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)](https://flutter.dev/docs/development/ui/widgets/material)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](./LICENSE)

**Healing Bloom** is a comprehensive mobile application designed to revolutionize dermatological self-care. By leveraging advanced image recognition (**Inspection Rusnet V2**) and machine learning, the app identifies potential skin diseases, analyzes facial features for personalized skincare recommendations, and provides an integrated e-commerce platform for medicines and cosmetics.

<p align="center">
  <img src="images/img1.jpg" alt="Healing Bloom App Preview" width="600"/>
</p>

---

## Table of Contents

- [✨ Features](#-features)
- [📸 App Gallery](#-app-gallery)
- [🛠 Tech Stack](#-tech-stack)
- [🚀 Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Backend Setup](#backend-setup)
  - [ML Model Integration](#ml-model-integration)
- [📂 Project Structure](#-project-structure)
- [🔮 Future Enhancements](#-future-enhancements)
- [🏆 Achievements](#-achievements)
- [🤝 Contributing](#-contributing)

---

## ✨ Features

### 🔍 Skin Disease Identification

- **AI-Powered Detection:** Utilizes the **Inspection Rusnet V2** model to analyze skin conditions.
- **Flexible Input:** Supports real-time camera scanning or importing images from the gallery.
- **Instant Results:** Provides immediate disease prediction with detailed information.

### 👤 Face Scanning & Personalization

- **Smart Analysis:** Scans the user's face using **Google ML Kit** to determine skin attributes.
- **Tailored Recommendations:** Suggests skincare routines and cosmetic products specifically suited to the user's skin type.

### 🛒 Integrated Shopping Platform

- **E-Commerce:** Browse a vast catalog of **Medicines** and **Cosmetics**.
- **User-Friendly:** Includes search, filter, and sort functionalities.
- **Secure Checkout:** Add items to the cart and complete purchases seamlessly.

---

## 📸 App Gallery

|              Skin Detection              |              Face Scanning               |                 Shopping                 |             Recommendations              |
| :--------------------------------------: | :--------------------------------------: | :--------------------------------------: | :--------------------------------------: |
| <img src="images/img2.jpg" width="200"/> | <img src="images/img3.jpg" width="200"/> | <img src="images/img4.jpg" width="200"/> | <img src="images/img5.jpg" width="200"/> |

---

## 🛠 Tech Stack

- **Frontend:** Flutter & Dart
- **State Management:** Provider
- **Machine Learning:** TensorFlow Lite (Inspection Rusnet V2), Google ML Kit (Face Detection)
- **Networking:** HTTP, Connectivity Plus
- **Storage:** Shared Preferences, Flutter Secure Storage
- **Backend:** REST APIs (Django/Python - _See Backend Repo_)

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK:** Version 3.x or higher
- **Dart SDK:** Version 3.x or higher
- **IDE:** VS Code or Android Studio
- **Backend Server:** The backend repository must be running locally or deployed.

### Installation

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/yourusername/healing_bloom.git
    cd healing_bloom
    ```

2.  **Install Dependencies**

    ```bash
    flutter pub get
    ```

3.  **Run the App**
    ```bash
    flutter run
    ```

### Backend Setup

⚠️ **Important:** This app requires the backend server to function correctly (Product data, Auth, etc.). The backend is built using **Django (Python)** and **PostgreSQL**.

#### Requirements

- **Python:** Version 3.8 or higher
- **Django:** Version 3.x or higher
- **PostgreSQL:** Database for storing user data and app information
- **Django REST Framework:** For creating the APIs

#### Installation Steps

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/Alan21303/Healing_Bloom_Backend.git
    cd Healing_Bloom_Backend
    ```

2.  **Set Up the Python Environment**

    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    pip install -r requirements.txt
    ```

3.  **Set Up PostgreSQL Database**
    - Install PostgreSQL and create a new database.
    - Update the `DATABASES` settings in `settings.py`:
      ```python
      DATABASES = {
          'default': {
              'ENGINE': 'django.db.backends.postgresql',
              'NAME': 'your_database_name',
              'USER': 'your_database_user',
              'PASSWORD': 'your_database_password',
              'HOST': 'localhost',
              'PORT': '5432',
          }
      }
      ```
    - Run migrations:
      ```bash
      python manage.py migrate
      ```

4.  **Start the Development Server**

    ```bash
    python manage.py runserver
    ```

    The API will be available at `http://127.0.0.1:8000/`.

5.  **Connect Flutter App**
    Update the API Base URL in your Flutter app (e.g., `lib/services/api_config.dart` or `.env`):
    ```dart
    const String baseUrl = 'http://127.0.0.1:8000'; // Or your local IP if running on device
    ```

### ML Model Integration

To enable Skin Disease Identification:

1.  Ensure the **Inspection Rusnet V2** TFLite model is placed in `assets/models/`.
2.  Verify `pubspec.yaml` includes the asset path:
    ```yaml
    flutter:
      assets:
        - assets/models/
    ```

---


## 📂 Project Structure

```plaintext
healing_bloom/
├── assets/
│   ├── animations/       # Lottie files
│   ├── data/             # Local JSON data (disease_data.json)
│   ├── icons/            # App icons
│   ├── images/           # UI Images
│   └── models/           # TFLite models
├── lib/
│   ├── models/           # Data models
│   ├── screens/          # UI Screens (Scan, Shop, Home)
│   ├── services/         # API & ML Services
│   ├── widgets/          # Reusable components
│   └── main.dart         # Entry point
├── pubspec.yaml          # Dependencies
└── README.md             # Documentation
```

---

## 🔮 Future Enhancements

- [ ] **Routine Reminders:** Push notifications for skincare routines.
- [ ] **Localization:** Multi-language support.

---

## 🏆 Achievements

- 📄 Published a conference paper at **ICTEST IEEE Conference**.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1.  Fork the repository.
2.  Create a new branch: `git checkout -b feature/YourFeature`.
3.  Commit your changes: `git commit -m 'Add some feature'`.
4.  Push to the branch: `git push origin feature/YourFeature`.
5.  Open a Pull Request.

---

## 🔗 Repositories

| Component                     | Repository Link                                                              |
| :---------------------------- | :--------------------------------------------------------------------------- |
| **📱 Frontend (Flutter)**     | [Healing Bloom App](https://github.com/yourusername/healing_bloom)           |
| **🖥️ Backend (Node/Express)** | [Healing Bloom Backend](https://github.com/alanroy003/Healing_Bloom_Backend) |

---

<p align="center">
  Made with ❤️ using Flutter
</p>
