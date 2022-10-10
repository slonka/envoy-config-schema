const typeToConfig = {
    "#/definitions/envoy.config.accesslog.v3.AccessLogFilter": [
        "envoy.access_loggers.file",
        "envoy.access_loggers.http_grpc",
        "envoy.access_loggers.open_telemetry",
        "envoy.access_loggers.stderr",
        "envoy.access_loggers.stdout",
        "envoy.access_loggers.tcp_grpc",
        "envoy.access_loggers.wasm"
    ]
}

const bootstrap = require("./build/v3_Bootstrap.json")
