FROM python:3.9
WORKDIR /app
COPY testapp.py .
CMD ["python", "testapp.py"]