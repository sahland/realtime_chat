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
cp .env.example .env
flutter pub get
dart run build_runner build
flutter run
```

## Стек

- **State management:** BLoC / Cubit
- **Networking:** Dio + Retrofit
- **WebSocket:** web_socket_channel
- **Routing:** GoRouter
- **Models:** json_serializable + Equatable

## Почему BLoC

Выбор BLoC обусловлен спецификой задачи — приложение работает с WebSocket-потоком событий, и BLoC отлично ложится на event-driven архитектуру. Каждое входящее WS-событие маппится на конкретный event блока, что делает поток данных прозрачным и предсказуемым. Для optimistic UI это критично: отправка сообщения, подтверждение от сервера и обработка ошибки — три отдельных события с чёткой логикой перехода между состояниями.

## Архитектура

Feature-first с разделением на слои:

```
lib/
├── core/           — конфигурация (base URL из .env)
├── data/
│   ├── api/        — Retrofit-клиенты (users, rooms, messages)
│   ├── websocket/  — WsService с auto-reconnect
│   └── repository/ — ChatRepository (единая точка доступа к данным)
├── domain/
│   └── model/      — User, Room, Message (json_serializable + Equatable)
├── features/
│   ├── users/      — выбор/создание пользователя (BLoC + view + widgets)
│   ├── rooms/      — список диалогов (BLoC + view + widgets)
│   └── chat/       — переписка с Optimistic UI (BLoC + view + widgets)
└── router/         — GoRouter
```

Ключевые решения:
- **WebSocket вынесен в отдельный сервис** (`WsService`), не привязан к виджетам — управление подключением, reconnect и парсинг событий происходят на уровне data-слоя
- **Repository как фасад** — BLoC не знает о Dio/Retrofit/WebSocket напрямую, работает только через `ChatRepository`
- **Optimistic UI** — сообщение появляется в списке сразу после отправки со статусом `sending`, при получении `message.created` статус меняется на `sent` (сопоставление по `client_message_id`), при `error` — помечается ошибкой
- **Дедупликация** — входящие сообщения проверяются и по `client_message_id` (свои), и по `message.id` (чужие), дубликаты после reconnect исключены
