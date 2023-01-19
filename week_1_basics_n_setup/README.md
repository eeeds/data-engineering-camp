# Set up

## Introduction to Docker
[More info here](https://www.youtube.com/watch?v=EYNwNlOrpr0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=4)
## Why should we care about docker?
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package. By doing so, thanks to the container, the developer can rest assured that the application will run on any other Linux machine regardless of any customized settings that machine might have that could differ from the machine used for writing and testing the code.

## First command using docker
Run a image called `hello-world`
```
docker run hello-world
```
## Python Image
Run a image called `python`
```
docker run -it python:3.9
```
where:
- `-it` is for interactive mode

### Installing pandas on it
First we have to access to the container, not in python.
```
docker run -it --entrypoint=bash python:3.9
```
where:
- `--entrypoint=bash` is for access to the container

Then we can install pandas
```
pip install pandas
```
The problem is that when we try to access to the container again, we woudn't be able to call pandas, we'll have to install it another time.

## Dockerfile
A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Using docker build users can create an automated build that executes several command-line instructions in succession.

### Dockerfile example
```
FROM python:3.9

RUN pip install pandas

ENTRYPOINT ["bash"]
```
where:
- `FROM` is for the base image
- `RUN` is for the command to run

## Build the image
```
docker build -t test:pandas .
```
where:
- `-t` is for the tag
- `.` means this directory.

## Run the image
```
docker run -it test:pandas
```

## Testing our docker container with a python script
I'll create a python script called `pipeline.py` with the following content:
```
import pandas as pd

df = pd.DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]})

print(df)

```
Then I'll add these lines to the docker container:
```
WORKDIR /app
COPY pipeline.py pipeline.py
ENTRYPOINT ["python", "pipeline.py"]
```
where:
- `WORKDIR` is for the directory
- `COPY` is for copy the file

## Build the docker image again
```
docker build -t test:pandas .
```
## Run it
```
docker run -it test:pandas
```

## Ingesting NY Taxi Data to Postgres
[More info here](https://www.youtube.com/watch?v=2JM-ziJt0WI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

