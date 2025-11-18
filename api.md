# API SellerProof для Flutter разработчиков

## Базовый URL

```
https://d5dok9vujep8na8ceXxx.4xxx.apigw.yandexcloud.net/grpc/
```

Все gRPC вызовы производятся через этот URL по протоколу HTTP/2 с использованием gRPC клиента.

***

## Аутентификация

- Используется JWT токен в HTTP-заголовке `authorization: Bearer <jwt-token>`
- Токен получают при регистрации и логине
- Токен обновляется через refresh token
- Исключение — метод получения публичного видео и регистрация, которые не требуют аутентификации

***

## Основные gRPC методы

### 1. Регистрация и верификация email

- **Register**: создаёт пользователя + организацию (опционально), отправляет email с кодом
- **VerifyEmail**: подтверждение email по коду верификации
- **Login**: аутентификация с email и паролем
- **RefreshToken**: обновление JWT токена

### 2. Работа с видео

- **InitiateMultipartUpload**: старт multipart загрузки, возвращает uploadId и рекомендации для клиента
- **GetPartUploadURLs**: получение presigned url для частей видео
- **CompleteMultipartUpload**: завершение multipart загрузки
- **AbortMultipartUpload**: отмена multipart загрузки
- **ListVideos**: список видео пользователя
- **SearchVideos**: поиск видео по названию (полнотекстовый)
- **GetVideoDownloadURL**: получение presigned url для скачивания конкретного видео
- **DeleteVideo**: удаление видео

### 3. Публичный доступ (sharing)

- **CreatePublicShareLink**: создание публичной ссылки на видео с optional сроком действия
- **GetPublicVideo**: получение информации и ссылки по публичному токену
- **RevokeShareLink**: отзыв публичной ссылки

### 4. Управление организациями и ролями

- **CreateOrganization**: создание новой организации
- **InviteUser**: приглашение пользователя в организацию с ролью
- **UpdateUserRole**: изменение роли пользователя в организации
- **RemoveUser**: удаление пользователя из организации
- **ListMembers**: список участников организации

### 5. Подписки и биллинг

- **GetSubscription**: информация о подписке организации
- **GetStorageUsage**: статистика usage и лимиты хранения
- **InitPayment**: инициация платежа через Тинькофф, возвращает URL для оплаты
- **CheckPaymentStatus**: проверка статуса платежа

***

## Документация по структурам сообщений (protobuf)

Пример основных запросов/ответов для Flutter gRPC кода (сгенерированного из proto):

```dart
// Регистрация
final registerRequest = RegisterRequest(
  email: 'user@example.com',
  password: 'securePassword',
);

// Логин
final loginRequest = LoginRequest(
  email: 'user@example.com',
  password: 'securePassword',
);

// multipart upload инициируем
final initiateRequest = InitiateMultipartUploadRequest(
  orgId: 'org-uuid',
  fileName: 'video.mp4',
  fileSizeBytes: 1500000000,  // пример 1.5GB
  durationSeconds: 1800,      // 30 минут
);

// Получаем pre-signed URLs для частей
final partUrlsRequest = GetPartUploadURLsRequest(
  videoId: 'video-uuid',
  totalParts: 30,
);

// Завершаем multipart upload
final completeRequest = CompleteMultipartUploadRequest(
  videoId: 'video-uuid',
  parts: [
    CompletedPart(partNumber: 1, etag: 'etag1'),
    CompletedPart(partNumber: 2, etag: 'etag2'),
    // ...
  ],
);
```

***

## Полезная информация для разработки Flutter клиента

- Используйте официальный [gRPC Dart пакет](https://pub.dev/packages/grpc)
- Обязательно передавайте JWT токен в метаданных gRPC запросов (`metadata: {'authorization': 'Bearer <token>'}`)
- Реализуйте multipart upload с параллельной отправкой частей по pre-signed URLs, получаемым через API
- Для поиска используйте метод `SearchVideos`, передавая строку запроса
- Для публичного доступа к видео используйте `GetPublicVideo` без токена (по публичному токену)

***

## Особенности

- Все операции, кроме получения публичного видео и регистрации/входа, требуют JWT аутентификации
- API Gateway проксирует все gRPC запросы по пути `/grpc/{proxy+}`
- Платежи проходят через интеграцию с Тинькофф, для инициации платежа используйте `InitPayment`, для проверки — `CheckPaymentStatus`
- Видео хранятся в Yandex Object Storage, загрузка идёт напрямую с клиента по pre-signed URL
- Максимальная длина видео — 30 минут
- Размер части multipart upload — 50 MB

***

Если нужна помощь с примерами кода Flutter по конкретным методам — могу предоставить готовые шаблоны.  
Также рекомендую изучить детали API и proto-файлы в репозитории [sellerproof-backend](https://github.com/lumiforge/sellerproof-backend) для полной картины.

[1](https://github.com/lumiforge/sellerproof)