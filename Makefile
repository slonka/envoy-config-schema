install-deps:
	git submodule update --init --recursive
	# We need to declare commits here because using tag names does not play well on CI.
	# Taken from https://github.com/envoyproxy/envoy/blob/v1.22.0/api/bazel/repository_locations.bzl
	cd ./libs/github.com/cncf/xds && git checkout 7f1daf1720fc185f3b63f70d25aefaeef83d88d7
	cd ./libs/github.com/envoyproxy/protoc-gen-validate && git checkout 4694024279bdac52b77e22dc87808bd0fd732b69
	cd ./libs/github.com/googleapis/googleapis && git checkout 82944da21578a53b74e547774cf62ed31a05b841
	cd ./libs/github.com/census-instrumentation/opencensus-proto && git checkout 4aa53e15cbf1a47bc9087e6cfdca214c1eea4e89
	cd ./libs/github.com/open-telemetry/opentelemetry-proto && git checkout b43e9b18b76abf3ee040164b55b9c355217151f3
	cd ./libs/github.com/prometheus/client_model && git checkout 147c58e9608a4f9628b53b6cc863325ca746f63a
	cd ./libs/github.com/envoyproxy/envoy && git checkout dcd329a2e95b54f754b17aceca3f72724294b502 #v1.22.0

	go install github.com/chrusty/protoc-gen-jsonschema/cmd/protoc-gen-jsonschema@1.3.9
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

generate-json-schema:
	$(MAKE) generate-json-schema-version VERSION=v2
	$(MAKE) generate-json-schema-version VERSION=v3

BUILD_DIR=./build
BUILD_TMP_DIR=$(BUILD_DIR)/tmp

generate-json-schema-version:
	@-rm -rf $(BUILD_TMP_DIR) && mkdir -p $(BUILD_TMP_DIR)
	@protoc --jsonschema_out=$(BUILD_TMP_DIR) \
		-I$(PWD)/libs/github.com/protobuf/src/ \
		-I$(PWD)/libs/github.com/cncf/xds \
		-I$(PWD)/libs/github.com/cncf/udpa \
		-I$(PWD)/libs/github.com/envoyproxy/protoc-gen-validate \
		-I$(PWD)/libs/github.com/googleapis/googleapis \
		-I$(PWD)/libs/github.com/census-instrumentation/opencensus-proto/src \
		-I$(PWD)/libs/github.com/open-telemetry/opentelemetry-proto \
		-I$(PWD)/libs/github.com/prometheus/client_model \
		-I$(PWD)/libs/github.com/envoyproxy/envoy/api \
		$(PWD)/libs/github.com/envoyproxy/envoy/api/envoy/config/bootstrap/$(VERSION)/bootstrap.proto
	ls $(BUILD_TMP_DIR) | xargs -I {} mv $(BUILD_TMP_DIR)/{} $(BUILD_DIR)/$(VERSION)_{}
	rm -rf $(BUILD_TMP_DIR)
