# Используем базовый образ Node.js 22.10 на Alpine Linux для сборки приложения
FROM node:22.10-alpine AS Builder
# Установка рабочего каталога в контейнере
WORKDIR /app
# Копирование файлов package.json и package-lock.json (если есть) в рабочую директорию
COPY package*.json ./
# Устанавливаем зависимости
RUN npm ci
# Копирование всех файлов проекта в рабочую директорию
COPY . .
# Сборка приложения
RUN npm run build

# Финальный этап с легковесным образом Nginx
FROM nginx:stable-alpine
# Копируем собранные файлы из этапа сборки
COPY --from=builder /app/dist /usr/share/nginx/html
# Копируем кастомный конфиг для Nginx
COPY nginx.conf /etc/nginx/nginx.conf
# Экспонируем порт
EXPOSE 80
# Запуск Nginx
CMD ["nginx", "-g", "daemon off;"]
