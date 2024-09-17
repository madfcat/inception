FROM alpine:3.19

# # Prevent Python from writing .pyc files to the container’s filesystem
# ENV PYTHONDONTWRITEBYTECODE 1

# # Set stdout and stderr is sent to the terminal without being buffered
# ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /usr/src/app

COPY ./src/app .

# Install packages
RUN apk update && apk add --no-cache \
	python3 \
	py3-pip

RUN pip install -r requirements.txt

CMD ["python", "manage.py", "runserver"]