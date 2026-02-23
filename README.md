# Healing Bloom - Flutter App
Healing Bloom is a mobile application designed to help users identify skin diseases using advanced image recognition and offer personalized product recommendations. The app uses **Inspection Rusnet V2** for skin disease detection and integrates face scanning features to suggest relevant products. Additionally, users can explore and shop for medicines and cosmetics from an integrated online shopping platform.
![App Preview](images/img1.jpg)
---
## Features
- **Skin Disease Identification**  
  ![Skin Detection Feature](images/img2.jpg)  
  Using Inspection Rusnet V2, the app scans skin conditions and identifies possible diseases.
- **Face Scanning for Product Recommendations**  
  ![Face Scanning](images/img3.jpg)  
  The app scans the user's face to recommend skincare and cosmetic products suitable for their skin type.
- **Integrated Shopping Platform**  
  ![Shopping Section](images/img4.jpg)  
  Users can browse and purchase medicines and cosmetics directly from the app.
- **Personalized Recommendations**  
  ![Recommendations](images/img5.jpg)  
  Based on the detected skin condition, the app suggests appropriate skincare routines and products.
---
## Repositories

| Part | Repository |
|------|-----------|
| 📱 Frontend (Flutter) | [healing_bloom](https://github.com/yourusername/healing_bloom) |
| 🖥️ Backend | [Healing_Bloom_Backend](https://github.com/alanroy003/Healing_Bloom_Backend) |

> Both repositories are required for full functionality. Make sure the backend server is running before launching the Flutter app.

---
## Requirements
- **Flutter SDK**: Version 3.x or higher  
- **Dart SDK**: Version 2.x or higher  
- **IDE**: Android Studio or VS Code  
- **Supported Platforms**: Android & iOS
---
## Installation
```bash
git clone https://github.com/yourusername/healing_bloom.git
cd healing_bloom
flutter pub get
```
> If you're new to Flutter, follow the [official installation guide](https://flutter.dev/docs/get-started/install).
---
## Backend Setup

The backend for Healing Bloom is maintained in a separate repository. It handles API services, product data, and other server-side functionality required by the app.

🔗 **Backend Repository**: [Healing Bloom Backend](https://github.com/alanroy003/Healing_Bloom_Backend)

### Getting Started with the Backend

1. **Clone the backend repository**
   ```bash
   git clone https://github.com/alanroy003/Healing_Bloom_Backend.git
   cd Healing_Bloom_Backend
   ```

2. **Follow the setup instructions** in the backend repository's README to install dependencies and configure the environment.

3. **Configure the Flutter app** to point to your backend server by updating the base API URL in the app's configuration file (e.g., `lib/services/api_config.dart` or equivalent):
   ```dart
   const String baseUrl = 'http://your-backend-url';
   ```

4. **Run the backend server** before launching the Flutter app to ensure full functionality.

> **Note:** Some features like product recommendations, shopping, and skin history tracking depend on an active backend connection.

---
## Setting Up Inspection Rusnet V2
![Model Integration](images/img6.jpg)
To use Inspection Rusnet V2 for skin disease identification:
1. **Download the Model**  
2. **Integrate the TFLite model into your app**  
3. **Run sample tests using camera or gallery images**

Use TensorFlow Lite or any Flutter-compatible ML framework to load and run the model.
---
## Face Scanning and Product Recommendation
![Face Analysis](images/img7.jpg)
1. Implement face detection using packages like [Google ML Kit](https://pub.dev/packages/google_mlkit_face_detection).  
2. Feed results into the recommendation engine.  
3. Display recommended products.
---
## Shopping Platform
![Store](images/img8.jpg)
- Explore categories like **Medicines** and **Cosmetics**
- Search, filter, and sort products
- Add to cart and checkout securely
---
## Project Structure
```
/healing_bloom
|-- /images               # All UI images (img1.jpg - img10.jpg)
|-- /lib
|   |-- /screens
|   |-- /models
|   |-- /services
|   |-- main.dart
```
---
## Usage
### Scan Skin
![Scan Skin](images/img9.jpg)
1. Open **Scan Skin** tab  
2. Take or upload a photo  
3. View disease prediction and related products  
### Scan Face for Products
1. Open **Face Scan** tab  
2. Grant camera access  
3. Get personalized recommendations
---
### Shopping
![Shopping Cart](images/img10.jpg)
1. Browse products  
2. Add to cart  
3. Complete the purchase  
---
## Technologies Used
- Flutter & Dart  
- TensorFlow Lite (Inspection Rusnet V2)  
- Firebase (Optional Backend)  
- Face Detection (Google ML Kit or alternative)  
- REST APIs for shopping integration  
---
## Future Enhancements
- User login/profile  
- Skin history tracking  
- Routine reminders  
- Language localization
---
## Contributing
Pull requests are welcome! Please follow these steps:
```bash
git checkout -b feature-name
git commit -m "Add new feature"
git push origin feature-name
```
Open a PR on GitHub. 🎉

> For backend contributions, please visit the [Healing Bloom Backend repository](https://github.com/alanroy003/Healing_Bloom_Backend).

---
