# Realtime Chat

Flutter-приложение для обмена сообщениями в реальном времени.

## Запуск бэкенда

```bash
cd Back
docker compose up --build
```

API доступен на `http://localhost:8088`.

## Запуск приложения

```bash
flutter pub get
flutter run
```

## Стек

- **State management:** BLoC / Cubit
- **Networking:** Dio + Retrofit
- **WebSocket:** web_socket_channel
- **Routing:** GoRouter
- **Models:** json_serializable + Equatable

## Архитектура

Feature-first с разделением на слои:

- `core/` — конфигурация, константы
- `data/` — API-клиенты (Retrofit), WebSocket-сервис, репозитории
- `domain/` — модели данных
- `features/` — экраны с BLoC, view и widgets
- `router/` — навигация (GoRouter)
- `uikit/` — дизайн-система
