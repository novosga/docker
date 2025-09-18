FROM novosga/novosga:2.2.12

#Set the default parameters
ENV APP_ENV=prod \
    LANGUAGE=pt_BR \
    NOVOSGA_ADMIN_USERNAME="admin" \
    NOVOSGA_ADMIN_PASSWORD="123456" \
    NOVOSGA_ADMIN_FIRSTNAME="Administrador" \
    NOVOSGA_ADMIN_LASTNAME="Global" \
    NOVOSGA_UNITY_NAME="Minha Unidade" \
    NOVOSGA_UNITY_CODE="U01" \
    NOVOSGA_NOPRIORITY_NAME="Normal" \
    NOVOSGA_NOPRIORITY_DESCRIPTION="Serviço normal" \
    NOVOSGA_PRIORITY_NAME="Prioridade" \
    NOVOSGA_PRIORITY_DESCRIPTION="Serviço prioritário" \
    NOVOSGA_PLACE_NAME="Guichê"

USER root

# https://github.com/aptible/supercronic/releases/tag/v0.2.33
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
    SUPERCRONIC=supercronic-linux-amd64

RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

COPY start.sh /usr/local/bin
COPY consumer.sh /usr/local/bin
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/crontab /etc/crontab

USER nobody

CMD ["start.sh"]
