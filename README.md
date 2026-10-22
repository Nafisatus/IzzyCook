# IzzyCook

A Flutter mobile app for searching and browsing recipes from around the world, powered by [TheMealDB API](https://www.themealdb.com/api.php).

## Description

IzzyCook helps beginners and students find recipes by name. Recipe data is fetched dynamically from the API and shown in a list that can be filtered by country of origin. Users can open a detail page to see the ingredients and cooking instructions.

## Main Features

- Search recipes by keyword
- Filter recipes by country of origin
- Detail page: photo, category, ingredients with measures, and cooking steps
- Loading, success, and error states handled with `FutureBuilder`
- "Try Again" button when fetching data fails

## Tech Stack

- Flutter & Dart
- [`http`](https://pub.dev/packages/http) package for HTTP requests
- TheMealDB API: `https://www.themealdb.com/api/json/v1/1/search.php?s=<keyword>`

## Folder Structure

```
lib/
├── main.dart
├── models/meal.dart
├── services/meal_service.dart
├── screens/
│   ├── home_screen.dart
│   └── detail_screen.dart
└── widgets/
    ├── meal_card.dart
    └── error_view.dart
```

## How to Run

1. Make sure the Flutter SDK is installed (`flutter doctor`).
2. Clone the repository:
```bash
   git clone https://github.com/Nafisatus/IzzyCook.git
   cd IzzyCook
```
3. Install dependencies:
```bash
   flutter pub get
```
4. Start an emulator or connect a device, then run:
```bash
   flutter run
```