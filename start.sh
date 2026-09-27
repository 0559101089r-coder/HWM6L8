#!/bin/sh

# Останавливаем выполнение при любой ошибке
set -e

echo "Применение миграций БД..."
python manage.py migrate --noinput

echo "Сборка статических файлов..."
python manage.py collectstatic --noinput

echo "Запуск Gunicorn..."
exec gunicorn core.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120