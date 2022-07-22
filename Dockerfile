FROM haskell:8.10.7-slim AS dev
RUN apt-get update && \
    apt-get install -y sqlite3
WORKDIR /workdir
RUN stack --resolver lts-18.28 install ghcid
COPY ./server/package.yaml ./server/stack.yaml ./server/example.cabal .
RUN stack build --only-dependencies
COPY ./server .
CMD ghcid --command "stack ghci --main-is example:app" --test main


FROM dev AS builder
RUN stack build && \
    mv $(stack path --local-install-root)/bin /workdir/bin


FROM node:14.16 AS front-dev
WORKDIR /workdir
RUN yarn global add purescript@0.15.4 --unsafe-perm && \
    yarn global add spago@0.20.9 --unsafe-perm && \
    yarn global add esbuild
COPY ./front/package.json ./front/yarn.lock .
RUN yarn install
COPY ./front/spago.dhall ./front/packages.dhall .
RUN spago install
COPY ./front .
RUN spago build

FROM front-dev AS front
RUN spago bundle-app --main Main --to public/index.js && \
    yarn parcel build --public-url static public/index.html
RUN ls -al public


FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y sqlite3
WORKDIR /workdir
COPY --from=builder /workdir/bin /workdir/bin
COPY --from=builder /workdir/db /workdir/db
COPY --from=front /workdir/dist/index.html /workdir/public/index.html
COPY --from=front /workdir/dist /workdir/public/static
EXPOSE 8000
CMD /workdir/bin/app
