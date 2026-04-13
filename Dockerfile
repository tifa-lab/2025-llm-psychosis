FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

ARG NB_USER=jovyan
ARG NB_UID=1000
ARG NB_GID=100

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl sudo && \
    useradd -m -s /bin/bash -N -u ${NB_UID} -g ${NB_GID} -o ${NB_USER}

RUN curl -fsSL https://pixi.sh/install.sh | PIXI_HOME=/usr/local bash

WORKDIR /opt/env
COPY pixi.toml pixi.lock* ./

RUN pixi install && pixi clean cache --yes

RUN pixi run --manifest-path /opt/env/pixi.toml R -e "install.packages('multgee', repos='https://cloud.r-project.org')"

COPY scripts/init-env.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/init-env.sh

RUN chown -R ${NB_UID}:${NB_GID} /opt/env

RUN echo 'alias pixi="pixi --manifest-path /opt/env/pixi.toml"' >> /home/${NB_USER}/.bashrc

WORKDIR /home/${NB_USER}/work
USER ${NB_UID}
EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/init-env.sh"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
