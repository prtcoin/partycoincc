FROM python:3.9.12-alpine3.15

ADD requirements.txt /app/requirements.txt

RUN set -ex \
    && apk add --no-cache --virtual .build-deps postgresql-dev build-base libffi-dev \
    && python -m venv /env \
    && /env/bin/pip install --upgrade pip \
    && /env/bin/pip install --no-cache-dir -r /app/requirements.txt \
    && runDeps="$(scanelf --needed --nobanner --recursive /env \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps

ADD . /app
WORKDIR /app

ENV DEBUG="off"
ENV SECRET_KEY=''
ENV DATABASE_NAME="partycoincc"
ENV DATABASE_USER="partycoincc"
ENV DATABASE_PASSWORD="Password1!"
ENV DATABASE_HOST="127.0.0.1"
ENV DATABASE_PORT="5432"
ENV DATABASE_CON_MAX_AGE="600"
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV SECRET_KEY=""

RUN /env/bin/python manage.py collectstatic --no-input

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

EXPOSE 8000

CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "partycoincc.wsgi"]
