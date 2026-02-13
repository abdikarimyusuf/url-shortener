FROM python:3.12-slim AS build
WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/src/

FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN addgroup --system app \
 && adduser  --system --ingroup app --no-create-home app

COPY --from=build /usr/local /usr/local

COPY --from=build /app/src/ /app/src/

USER app

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host=0.0.0.0", "--port=8080"]




# ENV PYTHONPATH=/app \
#     TABLE_NAME=changeme
# WORKDIR /app
# COPY --from=build /out /usr/local
# COPY --from=build /w/src /app
# USER 65532:65532
# EXPOSE 8080
# CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
