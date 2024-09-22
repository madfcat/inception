FROM alpine:3.19

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

CMD ["gunicorn", "--workers=3", "--bind=0.0.0.0:8000", "app.wsgi:application"]