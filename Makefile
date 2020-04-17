.DEFAULT_GOAL := start

pull:
	docker pull jwilder/nginx-proxy
	docker pull jrcs/letsencrypt-nginx-proxy-companion

stop:
	docker stop nginx-proxy lets-encrypt
	docker rm nginx-proxy lets-encrypt

start:
	docker run --detach \
			--name nginx-proxy \
			--publish 80:80 \
			--publish 443:443 \
			--volume /etc/nginx/certs \
			--volume /etc/nginx/vhost.d \
			--volume /usr/share/nginx/html \
			--volume /var/run/docker.sock:/tmp/docker.sock:ro \
			--env-file nginx.env \
			jwilder/nginx-proxy
	docker run --detach \
			--name nginx-proxy-letsencrypt \
			--volumes-from nginx-proxy \
			--volume /var/run/docker.sock:/var/run/docker.sock:ro \
			--env-file letsencrypt.env \
			jrcs/letsencrypt-nginx-proxy-companion

update: pull stop start
