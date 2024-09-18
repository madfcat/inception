FROM alpine:3.19

# # Prevent Python from writing .pyc files to the container’s filesystem
# ENV PYTHONDONTWRITEBYTECODE 1

# # Set stdout and stderr is sent to the terminal without being buffered
# ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /usr/src/app

COPY ./src/ /usr/src/

# Install packages
RUN apk update && apk add --no-cache \
	python3 \
	py3-pip

# Install virtualenv
RUN python -m venv /opt/venv

# Activate virtualenv and install dependencies
RUN . /opt/venv/bin/activate && pip install --upgrade pip && pip install -r /usr/src/requirements.txt

# Activate virtualenv in shell 
ENV PATH="/opt/venv/bin:$PATH"

RUN mkdir -p /usr/src/app/staticfiles
RUN chmod -R 755 /usr/src/app/staticfiles

RUN python manage.py collectstatic --noinput

# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD ["gunicorn", "--workers=3", "--bind=0.0.0.0:8000", "app.wsgi:application"]

# CMD ["python", "manage.py", "runserver", "127.0.0.1:8000"]