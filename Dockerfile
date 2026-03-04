FROM python:3.12-slim AS base
WORKDIR /app
COPY requirements.txt .

FROM base AS test
COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt
COPY . .
CMD ["pytest", "-v"]

FROM base AS dev
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["flask", "--app", "run", "run", "--debug", "--host", "0.0.0.0"]

FROM base AS production
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "run:app"]