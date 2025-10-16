# Используем официальный образ Flutter для сборки
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./

RUN flutter pub get

COPY . .

RUN flutter pub get

# Позволяет переопределить base href при сборке (по умолчанию '/')
ARG BASE_HREF=/
ENV BASE_HREF=${BASE_HREF}

# Собираем веб-приложение для продакшена
RUN flutter build web --release --base-href ${BASE_HREF}

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
