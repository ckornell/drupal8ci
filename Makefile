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

test: clean-containers build run_tests

build:
	$(call docker_build,drupal8ci_8_6,./8.6)

run_tests:
	$(call docker_tests,drupal8ci_8_6)

clean: clean-containers clean-images

clean-containers:
	$(call docker_clean,drupal8ci_8_6)

clean-images:
	-docker rmi drupal8ci_8_6;

.PHONY: test clean