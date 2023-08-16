FROM python:3.10-slim-buster

# create and change dir 
WORKDIR /src

# copy source code of the application 
COPY ./analytics .

# install all dependencies 
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

## expected parameters
# APP_PORT      5153
# DB_USERNAME
# DB_PASSWORD
# DB_HOST       "127.0.0.1"
# DB_PORT       "5432"
# DB_NAME       "postgres"
ENTRYPOINT [ "python", "app.py" ] 