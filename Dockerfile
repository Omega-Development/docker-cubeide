FROM debian:latest as builder

LABEL org.opencontainers.image.authors="Anthony Williams <anthony@omegadev.net>"
LABEL org.opencontainers.image.description="STM32CubeIDE 1.14.0"
LABEL org.opencontainers.image.url="https://www.st.com/en/development-tools/stm32cubeide.html"
LABEL org.opencontainers.image.source="https://github.com/omega-development/docker-cubeide"

ENV DEBIAN_FRONTEND=noninteractive
ENV LICENSE_ALREADY_ACCEPTED=1
ENV TZ=Etc/UTC

RUN apt-get -y update && \
	apt-get -y install zip

#COPY en.st-stm32cubeide_1.14.0_19471_20231121_1200_amd64.deb_bundle.sh.zip /tmp/stm32cubeide-installer.sh.zip
COPY en.st-stm32cubeide_1.14.0_19471_20231121_1200_amd64.sh.zip /tmp/stm32cubeide-installer.sh.zip

RUN unzip -p /tmp/stm32cubeide-installer.sh.zip > /tmp/stm32cubeide-installer.sh && \
    rm /tmp/stm32cubeide-installer.sh.zip && \
    chmod +x /tmp/stm32cubeide-installer.sh && \
    /tmp/stm32cubeide-installer.sh --noexec --target /tmp/installer
RUN mkdir -p /opt/st/stm32cubeide && \
    tar zxf /tmp/installer/st-stm32cubeide*.tar.gz -C /opt/st/stm32cubeide
    #sh /tmp/stm32cubeide-installer.sh && \
    #rm /tmp/stm32cubeide-installer.sh

FROM debian:latest
COPY --from=builder /opt/st/stm32cubeide /opt/st/stm32cubeide
ENV PATH="${PATH}:/opt/st/stm32cubeide"
WORKDIR /workdir
# Install dependencies
#RUN apt-get -y -f install
