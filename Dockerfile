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

# Переходим в папку web проекта
WORKDIR /app/web

# Устанавливаем зависимости для веб-проекта
RUN flutter pub get

# Собираем веб-приложение для продакшена
RUN flutter build web --release --web-renderer html

# Используем nginx для хостинга статических файлов
FROM nginx:alpine

# Копируем собранные файлы в nginx
COPY --from=build /app/web/build/web /usr/share/nginx/html

# Копируем кастомную конфигурацию nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открываем порт 80
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
