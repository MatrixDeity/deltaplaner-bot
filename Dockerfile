FROM thevlang/vlang:latest AS builder
WORKDIR /build
COPY . .
RUN v -o deltaplaner-bot .

FROM ubuntu:focal
RUN apt-get update && apt-get install -y \
    libatomic1 \
    libsqlite3-dev \
    libssl-dev \
    tzdata
COPY --from=builder /build/deltaplaner-bot /work/
CMD ["/work/deltaplaner-bot", "-c", "/etc/deltaplaner-bot/deltaplaner.json"]
