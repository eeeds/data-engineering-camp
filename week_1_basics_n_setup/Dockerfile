FROM python:3.9.16
RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2 pyarrow

WORKDIR /app
COPY upload-data.py /app

ENTRYPOINT ["python", "upload-data.py"]