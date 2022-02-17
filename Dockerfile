FROM node:17-alpine
ARG KEYCLOAK_VERSION=17.0.0

RUN apk add git patch &&\
    git clone https://github.com/keycloak/keycloak.git /keycloak
WORKDIR /keycloak
RUN git fetch origin tag $KEYCLOAK_VERSION --no-tags && \
    git checkout

COPY custom /custom

RUN cp /keycloak/themes/src/main/resources/theme/base/login/register.ftl /custom/login/ && \
    cp /keycloak/themes/src/main/resources/theme/base/login/login-update-profile.ftl /custom/login/

RUN patch /custom/login/register.ftl /custom/login/register.ftl.patch && \
    patch /custom/login/login-update-profile.ftl /custom/login/login-update-profile.ftl.patch && \
    patch /keycloak/themes/src/main/resources/theme/keycloak.v2/account/src/app/content/account-page/AccountPage.tsx /custom/account/src/app/content/account-page/AccountPage.tsx.patch && \
    chmod -R 777 /custom

WORKDIR /keycloak/themes/src/main/resources/theme/keycloak.v2/account/src

RUN npm install && npm run build

WORKDIR /

RUN cp -r /keycloak/themes/src/main/resources/theme/keycloak.v2/account/resources /custom/account && \
    rm -rf /keycloak && \
    apk del git patch
