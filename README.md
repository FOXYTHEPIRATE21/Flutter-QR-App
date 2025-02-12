# Flutter QR Code Scanner & Generator

A Flutter application that allows users to scan QR codes using their device's camera and generate QR codes from text or URLs. This project is a great example of how to implement QR code functionality in Flutter, perfect for learning or integrating into your own apps.

## Features

- **QR Code Scanning**: Scan QR codes using the device's camera.
- **QR Code Generation**: Generate QR codes from text or URLs.
- **URL Launcher**: Open scanned URLs directly in the browser.
- **Customizable App Icons**: Easily customize the app icon using `flutter_launcher_icons`.

## Dependencies

This project uses the following dependencies:

- `flutter`: The core framework for building the app.
- `qr_flutter`: A Flutter widget for rendering QR codes.
- `mobile_scanner`: A plugin for scanning QR codes using the device's camera.
- `flutter_launcher_icons`: A package to generate launcher icons for the app.
- `url_launcher`: A plugin for launching URLs in the browser.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/FOXYTHEPIRATE21/Flutter-QR-App.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd Flutter-QR-App
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

### Scanning QR Codes

1. Navigate to the "Scan QR Code" section.
2. Give permission and point the camera at a QR code to scan it.
3. The app will display the scanned data. If it's a URL, you can open it directly in the browser.

### Generating QR Codes

1. Navigate to the "Generate QR Code" section.
2. Enter the text or URL you want to encode.
3. The app will generate a QR code you can use.

### Customizing App Icons

1. Modify the `flutter_launcher_icons.yaml` file to customize the app icon.
2. Run the following command to generate the new icons:
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## Acknowledgments

- [qr_flutter](https://pub.dev/packages/qr_flutter) for the QR code generation widget.
- [mobile_scanner](https://pub.dev/packages/mobile_scanner) for the QR code scanning functionality.
- [url_launcher](https://pub.dev/packages/url_launcher) for launching URLs in the browser.
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) for customizing app icons.

## Support

If you find this project useful, consider giving it a star on [GitHub](https://github.com/FOXYTHEPIRATE21/Flutter-QR-App). Your support is greatly appreciated!