FROM node:17-alpine
ARG KEYCLOAK_VERSION=17.0.0

COPY custom /custom

RUN apk add --no-cache --virtual /.build-deps git patch &&\
    git clone https://github.com/keycloak/keycloak.git /keycloak && \
    git -C /keycloak fetch origin tag $KEYCLOAK_VERSION --no-tags && \
    git -C /keycloak checkout $KEYCLOAK_VERSION && \
    cp /keycloak/themes/src/main/resources/theme/base/login/register.ftl /custom/login/ && \
    cp /keycloak/themes/src/main/resources/theme/base/login/login-update-profile.ftl /custom/login/ && \
    patch /custom/login/register.ftl /custom/login/register.ftl.patch && \
    patch /custom/login/login-update-profile.ftl /custom/login/login-update-profile.ftl.patch && \
    patch /keycloak/themes/src/main/resources/theme/keycloak.v2/account/src/app/content/account-page/AccountPage.tsx /custom/account/src/app/content/account-page/AccountPage.tsx.patch && \
    chmod -R 777 /custom && \
    cd /keycloak/themes/src/main/resources/theme/keycloak.v2/account/src && \
    npm install && \
    npm run build && \
    cd / && \
    cp -r /keycloak/themes/src/main/resources/theme/keycloak.v2/account/resources /custom/account && \
    rm -rf /keycloak && \
    rm -rf /root/.npm && \
    apk del /.build-deps
