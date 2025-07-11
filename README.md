# 🤖 Gemma AI Chat

A modern, lightweight local AI chat application built with Flutter and powered by Google's Gemma-3-1B-IT model. Experience the power of on-device AI with beautiful UI/UX, secure data handling, and complete privacy.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![AI](https://img.shields.io/badge/AI-Gemma_3_1B_IT-red?style=for-the-badge)

## ✨ Features

### 🎯 Core Features
- **Local AI Processing**: Runs Gemma-3-1B-IT model entirely on your device
- **English Chat Interface**: Clean, focused chat experience in English
- **Secure API Key Storage**: Uses Flutter Secure Storage for encrypted key management
- **Persistent Chat History**: SQLite database for reliable conversation storage
- **Modern Material 3 UI**: Beautiful, responsive design with smooth animations

### 🚀 Advanced Features
- **Multiple Conversations**: Create, manage, and switch between different chat sessions
- **Message Management**: Copy, share, and delete individual messages
- **Export Conversations**: Share entire chat sessions
- **Real-time Typing Indicators**: Visual feedback during AI response generation
- **Offline Operation**: No internet required after initial model download

### 🎨 UI/UX Features
- **Clean Architecture**: Well-organized, maintainable codebase
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Animated Interactions**: Smooth transitions and micro-animations
- **Responsive Design**: Optimized for various screen sizes
- **Intuitive Navigation**: Easy-to-use drawer-based conversation management

## 📱 Screenshots

*Add screenshots here showing the beautiful UI*

## 🛠️ Technical Stack

### Frontend
- **Flutter 3.8.1+**: Cross-platform mobile development framework
- **Material 3**: Latest Material Design components
- **Provider**: State management solution
- **Flutter Animate**: Smooth animations and transitions

### AI & ML
- **Flutter Gemma**: Official Google Gemma integration
- **Gemma-3-1B-IT**: Google's lightweight instruction-tuned language model
- **LiteRT**: Optimized inference engine for mobile devices

### Storage & Database
- **SQLite**: Local database for chat history
- **Flutter Secure Storage**: Encrypted storage for sensitive data
- **Path Provider**: Cross-platform path management

### Additional Libraries
- **Google Fonts**: Beautiful typography
- **Share Plus**: Native sharing capabilities
- **URL Launcher**: External link handling
- **UUID**: Unique identifier generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Hugging Face account for API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/gemma-ai-chat.git
   cd gemma-ai-chat
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get your Hugging Face API Key**
   - Visit [Hugging Face](https://huggingface.co/)
   - Create an account and generate an API token
   - Accept the Gemma model license agreement

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Enter your API key**
   - On first launch, enter your Hugging Face API key
   - The app will automatically download and initialize the Gemma model

## 📋 Usage

### Initial Setup
1. Launch the app
2. Enter your Hugging Face API key
3. Wait for the model to download (one-time process)
4. Start chatting!

### Creating Conversations
- Tap the "+" button or use the drawer menu
- Each conversation maintains its own context
- Rename conversations by long-pressing

### Message Management
- Long-press messages for options
- Copy, share, or delete individual messages
- Export entire conversations

## 🏗️ Architecture

The project follows Clean Architecture principles:

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── services/           # Core services (storage, database)
│   └── theme/              # UI theme configuration
├── features/
│   └── chat/
│       ├── data/
│       │   ├── repositories/   # Data repositories
│       │   └── services/       # AI service implementation
│       ├── domain/
│       │   └── entities/       # Domain models
│       └── presentation/
│           ├── providers/      # State management
│           ├── screens/        # UI screens
│           └── widgets/        # Reusable components
└── main.dart               # App entry point
```

## 🔐 Security & Privacy

- **Local Processing**: All AI inference happens on your device
- **Encrypted Storage**: API keys stored using platform-specific secure storage
- **No Data Collection**: Your conversations never leave your device
- **Open Source**: Full transparency in code and data handling

## 🌍 Language Support

- 🇺🇸 **English**: Fully supported chat interface
- 🌐 **Other Languages**: The AI can understand and respond in various languages when you ask in those languages

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Google for the Gemma model
- Flutter team for the amazing framework
- Hugging Face for model hosting
- Open source community for various packages

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Contact me on [LinkedIn](https://linkedin.com/in/your-profile)

---

**Made with ❤️ and Flutter**