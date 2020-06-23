.PHONY: test generate gendoc docview analyze format genproto

test:
	@pub run test --concurrency=1 ./test

generate:
	@pub run build_runner build

gendoc:
	@dartdoc --no-auto-include-dependencies --no-include-source --show-progress

docview:
	@dhttpd --path doc/api

analyze:
	@dartanalyzer .

format:
	@dartfmt -w lib test

genproto:
	@protoc -I lib/src/protos/ lib/src/protos/beacons_v1.proto --dart_out=grpc:lib/src/generated
