FROM busybox
ARG KEYCLOAK_VERSION=17.0.0

COPY custom /custom

ADD https://raw.githubusercontent.com/keycloak/keycloak/$KEYCLOAK_VERSION/themes/src/main/resources/theme/base/login/register.ftl /custom/login/register.ftl
ADD https://raw.githubusercontent.com/keycloak/keycloak/$KEYCLOAK_VERSION/themes/src/main/resources/theme/base/login/login-update-profile.ftl /custom/login/login-update-profile.ftl
RUN patch /custom/login/register.ftl /custom/login/register.ftl.patch && \
    patch /custom/login/login-update-profile.ftl /custom/login/login-update-profile.ftl.patch && \
    chmod -R 777 /custom
