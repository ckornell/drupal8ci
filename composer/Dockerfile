FROM composer:latest

# Put a turbo on composer.
RUN composer global require hirak/prestissimo

# Install Robo CI.
RUN curl -fsSL https://robo.li/robo.phar -o robo.phar \
  && chmod +x robo.phar \
  && mv robo.phar /usr/local/bin/robo
