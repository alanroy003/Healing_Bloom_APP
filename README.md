Healing Bloom - Flutter App

Healing Bloom is a mobile application designed to help users identify skin diseases using advanced image recognition and offer personalized product recommendations. The app uses Inspection Rusnet V2 for skin disease detection and integrates face scanning features to suggest relevant products. Additionally, users can explore and shop for medicines and cosmetics from an integrated online shopping platform.

Features





Skin Disease Identification Using Inspection Rusnet V2, the app scans skin conditions and identifies possible diseases.



Face Scanning for Product Recommendations The app scans the user’s face to recommend skincare and cosmetic products suitable for their skin type.



Integrated Shopping Platform Users can browse and purchase medicines and cosmetics directly from the app.



Personalized Recommendations Based on the detected skin condition, the app suggests appropriate skincare routines and products.

Requirements





Flutter SDK: Version 3.x or higher



Dart SDK: Version 2.x or higher



IDE: Android Studio or VS Code



Supported Platforms: Android & iOS

Installation

git clone https://github.com/yourusername/healing_bloom.git
cd healing_bloom
flutter pub get


If you're new to Flutter, follow the official installation guide.

Setting Up Inspection Rusnet V2

To use Inspection Rusnet V2 for skin disease identification:





Download the Model



Integrate the TFLite model into your app



Run sample tests using camera or gallery images Use TensorFlow Lite or any Flutter-compatible ML framework to load and run the model.

Face Scanning and Product Recommendation







Implement face detection using packages like Google ML Kit.



Feed results into the recommendation engine.



Display recommended products.

Shopping Platform







Explore categories like Medicines and Cosmetics



Search, filter, and sort products



Add to cart and checkout securely

Project Structure

/healing_bloom
|-- /images               # All UI images (img1.jpg - img10.jpg)
|-- /lib
|   |-- /screens
|   |-- /models
|   |-- /services
|   |-- main.dart


Usage

Scan Skin







Open Scan Skin tab



Take or upload a photo



View disease prediction and related products

Scan Face for Products





Open Face Scan tab



Grant camera access



Get personalized recommendations

Shopping







Browse products



Add to cart



Complete the purchase

Technologies Used





Flutter & Dart



TensorFlow Lite (Inspection Rusnet V2)



Firebase (Optional Backend)



Face Detection (Google ML Kit or alternative)



REST APIs for shopping integration

Future Enhancements





User login/profile



Skin history tracking



Routine reminders



Language localization

Contributing

Pull requests are welcome! Please follow these steps:

git checkout -b feature-name
git commit -m "Add new feature"
git push origin feature-name


Open a PR on GitHub. 🎉

in this readme file add aoption for backend whch is in another repo

the backend is in the repo https://github.com/alanroy003/Healing_Bloom_Backend
