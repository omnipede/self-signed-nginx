# self-signed-nginx
Nginx self-signed SSL autoconfiguration script.

## Requirements
* ubuntu >= 18.0.4

## How to use

First, execute installation script inside this project folder.
```
$ pwd
/path/to/this/repo

$ sudo install.sh
```

After installation, write following nginx ```*.conf``` file on ```/etc/nginx/conf.d``` folder.
You should change some parts of the file.
1. Change ```example.com``` to your server domain name.
2. (Optional) Change ```example.access.log``` to preferrable log file name.
3. Change path of static files ```/srv/www/dist/``` to path you want.

```
server {
    listen 443 ssl;
    
    # Change me
    server_name example.com;
    
    # Change me
    access_log /var/log/nginx/example.access.log main;
    
    # This is for SPA routing feature of web front framework (e.g. React.js, Vue.js)
    location @rewrites {
    	rewrite ^(.+)$ /index.html last;
    }

    # Serve static files
    location / {
    
        # Change me
        root /srv/www/dist/;
        index index.html;
        try_files $uri $uri/ @rewrites;
    }
    
    gzip on;
    gzip_comp_level 2;
    gzip_proxied any;
    gzip_min_length 1000;
    gzip_disable    "MSIE [1-6]\."
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
}
```
As you know, the above file is a normal nginx server definition file.  
You can modify the file as you want based on official nginx syntax. 

After nginx configuration, start nginx processes by
```
$ sudo nginx -t
$ sudo service nginx start
```

## For development & testing
I've made [Dockerfile](./Dockerfile) for development of this shell script. You can use the dockerfile 
for multiple times of nginx installation while developing this script.

## TODO 
* Add "yes or no" input prompt at the start of the script. 
* Add self-signed ssl test script.
* Export secret string to configurations.
* Split installation script and configuration script.
