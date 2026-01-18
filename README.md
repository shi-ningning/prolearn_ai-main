# ProLearnAI - Learning Management System

An AI-powered learning companion built with Flutter and Firebase.

## 📁 Project Structure

```
prolearn_ai-main/
├── frontend/          # Flutter mobile & web application
├── backend/           # Backend services (API & Cloud Functions)
└── README.md          # This file
```

## 🚀 Quick Start

### Frontend (Flutter App)
```bash
cd frontend
flutter pub get
flutter run -d chrome  # For web
flutter run -d chrome --web-port 3000 --release
flutter run            # For mobile
```

### Backend (Coming Soon)
```bash
cd backend
# Backend setup instructions will be added
```

## 📱 Frontend

The frontend is a **Flutter** application that runs on:
- 🌐 Web (Chrome, Firefox, Safari)
- 📱 Mobile (Android & iOS)
- 💻 Desktop (Windows, macOS, Linux)

**Key Features:**
- User authentication with email verification
- Project management with progress tracking
- Task management system
- Course/syllabus tracking
- Real-time Firebase integration
- Multi-language support (English, Filipino, Bisaya)
- Dark/Light theme

**Tech Stack:**
- Flutter/Dart
- Firebase Auth
- Cloud Firestore
- Provider (State Management)

[See frontend/README.md for more details](./frontend/README.md)

## 🔧 Backend

The backend uses **Firebase** as Backend-as-a-Service (BaaS):
- Firebase Authentication
- Cloud Firestore (Database)
- Firebase Storage (File Storage)
- Cloud Functions (Serverless Functions)

**Future Additions:**
- Custom REST API (Node.js/Express)
- Admin Dashboard
- Analytics Service
- AI/ML Services

[See backend/README.md for more details](./backend/README.md)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Frontend (Flutter)                │
│  ┌─────────────────────────────────────────────┐   │
│  │  Presentation Layer (UI/Widgets/Pages)      │   │
│  └─────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────┐   │
│  │  State Management (Provider)                │   │
│  └─────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────┐   │
│  │  Data Layer (Repositories/Services)         │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────┐
│                   Backend (Firebase)                 │
│  ┌─────────────────────────────────────────────┐   │
│  │  Firebase Auth / Firestore / Storage        │   │
│  └─────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────┐   │
│  │  Cloud Functions (Optional)                 │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## 📚 Documentation

- [Frontend Documentation](./frontend/README.md)
- [Backend Documentation](./backend/README.md)
- [API Documentation](./backend/api/README.md) (Coming Soon)
- [Deployment Guide](./DEPLOYMENT.md) (Coming Soon)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

ProLearnAI Team - Building the future of intelligent learning

## 📞 Support

For support, email support@prolearnai.com or open an issue in this repository.