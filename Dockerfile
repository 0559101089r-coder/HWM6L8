FROM python:3.13-slim

# Отключаем буферизацию вывода Python и запрещаем создание .pyc файлов
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# 1. Обновляем существующие пакеты ОС до безопасных версий (убирает уязвимости)
# 2. Устанавливаем необходимые зависимости для сборки
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем и устанавливаем зависимости Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Копируем весь исходный код проекта
COPY . .

# Делаем скрипт start.sh исполняемым
RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]