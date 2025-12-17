FROM python:3.9-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache --virtual .build-deps gcc musl-dev \
    && pip install --no-cache-dir gunicorn==21.2.0

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Remove build dependencies to keep image small
RUN apk del .build-deps gcc musl-dev

COPY . .

EXPOSE 5000

# Optimize Gunicorn for t3.micro (1GB RAM)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "--worker-class", "sync", "run:app"]