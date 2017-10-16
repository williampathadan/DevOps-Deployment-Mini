# DevOps-Deployment-Mini

Topics:
 * Installing Docker
 * Building Docker images
 * Testing Docker containers

## Description
For this mini lab, we'll be getting Docker installed locally as well as using it to build an image and container. 
While this exercise isn't strictly related to deployment itself (since an actual production deployment process 
would have you deploy a whole bunch of containers instead of just a single one), it's good practice to work with 
a tool that sits within the overarching deployment workflow. We'll be creating an image of a node.js app you guys 
worked on: the old node hangman game! By the end of this mini lab, you'll have a docker container hosting your 
hangman server instead of having it run on your machine locally (though, strictly speaking it will still just 
be running on your machine, just within a container environment). 

There won't be much in the way of discovery or figuring stuff out on your own in this lab. Docker containers 
are complex under the hood, and letting you guys loose to figure stuff out on your own would most likely leave 
you all quite confused. For the non-extra credit tasks, you'll just be following step-by-step instructions to 
get things up and running. If you finish early (and you probably will), take the opportunity to 'dockerize' 
some other projects you've worked on /built using the flow you've just practiced. 

## Tasks
You'll notice that the node hangman server file has already been included in this repo. First off, we'll need 
to create an image of our node server. An image is essentially a snapshot of the files and environment that 
our application is running in. It's a read-only file that you download or create. The nice thing is that there 
are many images of popular software, tools, and distributions that have already created, and which we can 
extend our own images off of. We build an image by specifying instructions inside of a Dockerfile, which 
Docker then uses to build our image. That image then gets placed inside of a Docker container, which executes 
the image, thereby running the application that we placed inside it, all within the exact same environment in 
which that application was developed!

### Downloading Docker
The first thing you'll need to do is install the proper Docker executable for your operating system environment. 
We'll be using the Community Edition.
 * The OSX install page can be found [here](https://docs.docker.com/docker-for-mac/install/)
 * The Windows install page can be found [here](https://docs.docker.com/docker-for-windows/install/)
 * The Ubuntu install page can be found [here](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
If you're on some other Linux distro, you can find installation information [here](https://docs.docker.com/engine/installation/#server). 
Once you've installed Docker and ensured that it is working correctly on your machine, sign up for a Docker account as well. 
You'll need your Docker ID going forward.

### Creating a Dockerfile
So the first thing we need to do is create our Dockerfile. An empty one has already been provided for you. Open 
it up in a text editor. The first thing put in our Dockerfile is:
```
FROM node:8.7
```
This specifies that we want our image to extend the node version 8.7 Docker image which has already been created 
by the node.js maintainers. 

Next, we'll specify a working directory within our image's file structure to hold the application code inside 
our image. This will serve as the working directory of your application:
```
WORKDIR /
```

Since we're building off of the node 8.7 image, NPM is available, so the next thing we'll do is install our 
node app dependencies inside our image using the `npm` binary. We'll first need to copy our `package.json` 
and `package-lock.json` files into our image like so:
```
COPY package.json package-lock.json ./

RUN npm install
```

To bundle your app's source code inside the docker image, copy the rest of the contents:
```
COPY . .
```

The hangman server binds to port `8080`, so we'll need to use the EXPOSE command to have the port mapped 
by the docker daemon:
```
EXPOSE 8080
```

Lastly, we define the command to run our hangman server, which is simply `npm start`, which runs `node server.js`:
```
CMD ["npm", "start"]
```

Our finished dockerfile should look like this:
```
FROM node:8.7

WORKDIR /

COPY package.json package-lock.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD ["npm", "start"]
```

### Building the Image
With our Dockerfile complete, we're ready to build our image with Docker. We'll run the following command to do so:
```
$ docker build -t <your docker username>/devops-deployment-mini .
```

Your image will now be listed by Docker when you run the command `docker images`.

### Running the Image
Now, we'll run the image we just built with:
```
$ docker run -p 49160:8080 -d <your docker username>/devops-deployment-mini
```

The `-p 49160:8080` bit specifies the mapping between the port 8080 inside the container with a port on your local 
machine, in this case 49160.

The `docker run` command should have printed a long hash; that is your container ID. Use that to run `docker logs 
<container ID>` to see the output of your node server.

If you need to go inside the container, you can use the `exec` command like so:
```
$ docker exec -it <container ID> /bin/bash
```

### Testing the Image
To test the image running on your newly-created container, we can use `curl` to hit the endpoint that our container 
exposed (you should have `curl` installed on your machine at this point; if you don't, go install it). 

We can query the root route of our hangman server to see what we have guessed correctly as well as the letters we 
have guessed so far with:
```
curl -X GET http://localhost:49160
```

We can post a guess to our hangman server with the command:
```
curl -H "Content-Type: application/json" -X POST -d '{"letter":"s"}' http://localhost:49160/guess
```

That's it! You've successfully containerized a node app!

### Further Reading 
Of course, there's tons of information on Docker and its inner workings that we haven't touched on here in this 
mini lab. Some great resources to read in order to dig into this topic a bit more are the [official docs](https://docs.docker.com/) 
[This](https://www.sitepoint.com/docker-containers-software-delivery/) article also does a great job of 
motivating why Docker is such an important infrastructural technology, along with defining many of the Docker 
buzzwords and terminology. If you don't want to just read, try containerizing some other projects 
you've built using this same flow you just practiced!
