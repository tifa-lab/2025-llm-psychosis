#!/bin/bash
eval "$(pixi shell-hook --manifest-path /opt/env/pixi.toml)"
exec "$@"
