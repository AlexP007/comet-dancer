FROM nginx:1.21

MAINTAINER AlexP007

# Configs.
ADD nginx.conf    /etc/nginx/
ADD default.conf  /etc/nginx/conf.d/
ADD upstream.conf /etc/nginx/conf.d/

# Starting application.
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443