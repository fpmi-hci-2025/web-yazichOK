# Используем официальный образ Flutter для сборки
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем pubspec файлы
COPY pubspec.yaml pubspec.lock ./

# Устанавливаем зависимости
RUN flutter pub get

# Копируем исходный код
COPY . .

# Устанавливаем зависимости
RUN flutter pub get

# Собираем веб-приложение для продакшена с правильным base href
RUN flutter build web --release --base-href /web-yazichOK/

# Используем nginx для хостинга статических файлов
FROM nginx:alpine

# Копируем собранные файлы в nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Копируем кастомную конфигурацию nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открываем порт 80
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
