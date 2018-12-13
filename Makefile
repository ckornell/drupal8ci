# Makefile for Docker Compose Drupal images.

define dockerfile_build
	# Build image $(1)
	@cp "./tests/run-tests.sh" "./$(1)/";
	#    Done!
endef

define docker_build
	docker build -t=$(1) $(2);
endef

define docker_clean
	-docker stop $(1);
	-docker rm $(1);
endef

define docker_tests
	docker run --rm -t $(1) /scripts/run-tests.sh
endef

build:
	$(call dockerfile_build,8.6)

test: clean-containers build_base run_tests

build_base:
	$(call docker_build,base_8_6,./8.6)

run_tests:
	$(call docker_tests,base_8_6)

clean: clean-containers clean-images

clean-containers:
	# clean base.
	$(call docker_clean,base_8_6)

clean-images:
	-docker rmi base_8_6;

.PHONY: build test clean