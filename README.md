### Docker php5-alpine
```bash
docker run -d --name webserver -v /var/www:/var/lib/nginx/html -p 80:80 php5-alpine
```