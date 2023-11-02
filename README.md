## Laravel 10.3 | Octane | Swoole | Docker

## Build Image
```
sudo docker build -t $USER .
```

## Deploy Container
```
sudo docker run -d -p 8000:8000 --restart unless-stopped --name $USER -it $USER
```
