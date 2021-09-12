# home-medialab

## Clone

```sh
git clone https://github.com/cviorel/home-medialab.git
```

## Bring the stack up #1

```sh
cd home-medialab
./stack.sh up
```

## Bring the stack down #1

```sh
cd home-medialab
./stack.sh up
```

## Bring the stack up #2

```sh
# generate the commands
find . -type f -name docker-compose.yml | xargs -I {} echo "docker-compose -f {} up -d"

# execute
docker-compose -f ./apprise/docker-compose.yml up -d
docker-compose -f ./paperless-ng/docker-compose.yml up -d
docker-compose -f ./wikijs/docker-compose.yml up -d
docker-compose -f ./organizr/docker-compose.yml up -d
docker-compose -f ./media/docker-compose.yml up -d
docker-compose -f ./portainer/docker-compose.yml up -d
docker-compose -f ./pyLoad/docker-compose.yml up -d
docker-compose -f ./changedetection.io/docker-compose.yml up -d

```

## Bring the stack down #2

```sh
# generate the commands
find . -type f -name docker-compose.yml | xargs -I {} echo "docker-compose -f {} down"

# execute
docker-compose -f ./apprise/docker-compose.yml down
docker-compose -f ./paperless-ng/docker-compose.yml down
docker-compose -f ./wikijs/docker-compose.yml down
docker-compose -f ./organizr/docker-compose.yml down
docker-compose -f ./media/docker-compose.yml down
docker-compose -f ./portainer/docker-compose.yml down
docker-compose -f ./pyLoad/docker-compose.yml down
docker-compose -f ./changedetection.io/docker-compose.yml down

```

## Content

```yaml
.
├── apprise
│   └── docker-compose.yml
├── changedetection.io
│   └── docker-compose.yml
├── media
│   └── docker-compose.yml
├── organizr
│   └── docker-compose.yml
├── paperless-ng
│   └── docker-compose.yml
├── portainer
│   └── docker-compose.yml
├── wikijs
│   └── docker-compose.yml
├── deploy.sh
├── LICENSE
├── portainer-wrapper.ps1
└── README.md
```
