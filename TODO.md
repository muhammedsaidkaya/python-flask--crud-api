# API-exercise

This exercise is to assess your technical proficiency with Software Engineering, DevOps and Infrastructure tasks.
There is no need to do all the exercises, but try to get as much done as you can, so we can get a good feel of your skillset.
Don't be afraid to step outside your comfort-zone and try something new.

If you have any questions, feel free to reach out to us.

## Exercise

This exercise is split in several subtasks. We would like to see where you feel most comfortable and where you struggle.

### 0. Fork this repository

All your changes should be made in a **private** fork of this repository. When you're done please, please:

* Share your fork with the **container-solutions-test** user (Settings -> Members -> Share with Member)
* Make sure that you grant this user the Reporter role, so that our reviewers can check out the code using Git.
* Reply to the email that asked you to do this API exercise, with a link to the repository that the **container-solutions-test** user now should have access to.

### 1. Pick an API implementation

We provide you with existing implementations of API.
They are organized by the language and framework used at <https://gitlab.com/ContainerSolutions/titanic-api>.
Pick one and use it in your fork.
Feel free to make any required changes or additions to the code, but be mindful of the time.

### 2. Setup & fill database

Existing dataset is available in [titanic.csv](https://gitlab.com/ContainerSolutions/titanic-api/-/blob/master/titanic.csv).
Create a database and fill it with the given data.
SQL or NoSQL is your choice.

### 3. Dockerize

Containerize the application components with Docker, so they can be run everywhere comfortably with one or two commands.

> [Docker Desktop](https://www.docker.com/products/docker-desktop)

### 4. Deploy to Kubernetes

Enable your Docker containers to be deployed on a Kubernetes cluster.

> Don't have a Kubernetes cluster to test against?
>
> * [MiniKube](https://kubernetes.io/docs/setup/minikube/) (free, local)
> * [Docker Desktop Kubernetes](https://docs.docker.com/desktop/kubernetes/) (free, local)
> * [GKE](https://cloud.google.com/kubernetes-engine/) (more realistic deployment, may cost something)
>
> Remember that all scripts and code should be executable either on Linux or MacOS

### 5. Whatever you can think of

Do you have more ideas to optimize your workflow or automate deployment? Feel free to go wild and dazzle us with your solutions. Here's a couple of ideas:

* Implement a CI/CD pipeline
* Configure a logging or monitoring system
* Scan the Docker image for security vulnerabilities
