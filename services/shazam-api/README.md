This is the brain of the system.

It does NOT:
- process files
- render models

It ONLY:
- tracks workflow state

Why Flask?

Simple

Beginner friendly

Easy to containerize

Why not Django?

Too heavy

Not needed for microservices

docker build -t shazam-api services/shazam-api
docker tag shazam-api <dockerhub>/shazam-api:latest
docker push <dockerhub>/shazam-api:latest
