FROM perl:5.36

MAINTAINER AlexP007

ARG USER=www-data
ARG ROOT=/var/www
ARG CARMEL=$ROOT/.carmel
ARG APP=$ROOT/app

# Installing Carton.
RUN     cpanm Carmel --from https://www.cpan.org

# Creating cpanm dir.
RUN     mkdir -p -m 0755 $CARMEL && chown $USER $CARMEL && chgrp $USER $CARMEL

# Creating app root directory.
RUN     mkdir -p -m 0775 $APP && chown $USER $APP && chgrp $USER $APP

# Some security settings.
WORKDIR $APP
USER    $USER

# Starting application.
CMD     carmel install --verbose && carmel exec plackup -r -R lib -s Starman --workers=8 -p 5000 bin/app.psgi

EXPOSE  5000
