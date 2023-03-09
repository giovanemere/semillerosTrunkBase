# Repositorio semilleros Trunk Base

Ejemplo de Ejecucion shell pushGit.sh
 sh pushGit.sh "comentario" "rams" "clone"


## Step 1: Define the application dependencies


1. Create a directory for the project:
   ```
   $mkdir composetest
   $cd composetest
   ```
2. Create a file called `app.py` in your project directory and paste the following code in:
   ```
   import time

   import redis
   from flask import Flask

   app = Flask(__name__)
   cache = redis.Redis(host='redis', port=6379)

   def get_hit_count():
       retries = 5
       while True:
           try:
               return cache.incr('hits')
           except redis.exceptions.ConnectionError as exc:
               if retries == 0:
                   raise exc
               retries -= 1
               time.sleep(0.5)

   @app.route('/')
   def hello():
       count = get_hit_count()
       return 'Hello World! I have been seen {} times.\n'.format(count)
   ```


3. Create another file called `requirements.txt` in your project directory and paste the following code in:

```
flask
redis
```



## Step 2: Create a Dockerfile

The Dockerfile is used to build a Docker image. The image contains all the dependencies the Python application requires, including Python itself.

In your project directory, create a file named `Dockerfile` and paste the following code in:

```
# syntax=docker/dockerfile:1
FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
CMD ["flask", "run"]
```



## Step 3: Define services in a Compose file

Create a file called `docker-compose.yml` in your project directory and paste the following:

```
version: "3.9"
services:
  web:
    build: .
    ports:
      - "8000:5000"
  redis:
    image: "redis:alpine"
```


## Step 4: Build and run your app with Compose

1. From your project directory, start up your application by running `docker compose up`.
   ```
   $docker compose up

   Creating network "composetest_default" with the default driver
   Creating composetest_web_1 ...
   Creating composetest_redis_1 ...
   Creating composetest_web_1
   Creating composetest_redis_1 ... done
   Attaching to composetest_web_1, composetest_redis_1
   web_1    |  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
   redis_1  | 1:C 17 Aug 22:11:10.480 #
   ```


Enter http://localhost:8000/ in a browser to see the application running.

If this doesn’t resolve, you can also try http://127.0.0.1:8000.

You should see a message in your browser saying:

```
Hello World! I have been seen 1 times.
```


4. Switch to another terminal window, and type `docker image ls` to list local images.

Listing images at this point should return `redis` and `web`.

```
$docker image ls

REPOSITORY        TAG           IMAGE ID      CREATED        SIZE
composetest_web   latest        e2c21aa48cc1  4 minutes ago  93.8MB
python            3.4-alpine    84e6077c7ab6  7 days ago     82.5MB
redis             alpine        9d8fa9aa0e5b  3 weeks ago    27.5MB
```

You can inspect images with `docker inspect <tag or id>`.

5. Stop the application, either by running `docker compose down` from within your project directory in the second terminal, or by hitting CTRL+C in the original terminal where you started the app.


## Step 5: Edit the Compose file to add a bind mount

Edit `docker-compose.yml` in your project directory to add a [bind mount](https://docs.docker.com/storage/bind-mounts/) for the `web` service:

```
version: "3.9"
services:
  web:
    build: .
    ports:
      - "8000:5000"
    volumes:
      - .:/code
    environment:
      FLASK_DEBUG: "true"
  redis:
    image: "redis:alpine"
```

The new `volumes` key mounts the project directory (current directory) on the host to `/code` inside the container, allowing you to modify the code on the fly, without having to rebuild the image. The `environment` key sets the `FLASK_DEBUG` environment variable, which tells `flask run` to run in development mode and reload the code on change. This mode should only be used in development.

## Step 6: Re-build and run the app with Compose

From your project directory, type `docker compose up` to build the app with the updated Compose file, and run it.

```
$docker compose up

Creating network "composetest_default" with the default driver
Creating composetest_web_1 ...
Creating composetest_redis_1 ...
Creating composetest_web_1
Creating composetest_redis_1 ... done
Attaching to composetest_web_1, composetest_redis_1
web_1    |  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
...
```

Check the `Hello World` message in a web browser again, and refresh to see the count incremen


## Step 7: Update the application

Because the application code is now mounted into the container using a volume, you can make changes to its code and see the changes instantly, without having to rebuild the image.

Change the greeting in `app.py` and save it. For example, change the `Hello World!` message to `Hello from Docker!`:

```
return 'Hello from Docker! I have been seen {} times.\n'.format(count)
```

Refresh the app in your browser. The greeting should be updated, and the counter should still be incrementing.

![hello world in browser](https://docs.docker.com/compose/images/quick-hello-world-3.png)

## Step 8: Experiment with some other commands

If you want to run your services in the background, you can pass the `-d` flag (for “detached” mode) to `docker compose up` and use `docker compose ps` to see what is currently running:

```
$docker compose up -d

Starting composetest_redis_1...
Starting composetest_web_1...

$docker compose ps

       Name                      Command               State           Ports       
-------------------------------------------------------------------------------------
composetest_redis_1   docker-entrypoint.sh redis ...   Up      6379/tcp            
composetest_web_1     flask run                        Up      0.0.0.0:8000->5000/tcp
```

The `docker compose run` command allows you to run one-off commands for your services. For example, to see what environment variables are available to the `web` service:

```
$docker compose run web env
```

See `docker compose --help` to see other available commands.

If you started Compose with `docker compose up -d`, stop your services once you’ve finished with them:

```
$docker compose stop
```

You can bring everything down, removing the containers entirely, with the `down` command. Pass `--volumes` to also remove the data volume used by the Redis container:

```
$docker compose down --volumes
```
