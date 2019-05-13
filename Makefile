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

define file_build
	@cp -r ./8.x/ ./$(1)/;
	@DRUPAL_TAG="$(1)" envsubst < "./$(1)/drupal/Dockerfile.tpl" > "./$(1)/drupal/Dockerfile";
	@rm -f "./$(1)/drupal/Dockerfile.tpl";
	@DRUPAL_TAG="$(1)" envsubst < "./$(1)/no-drupal/Dockerfile.tpl" > "./$(1)/no-drupal/Dockerfile";
	@rm -f "./$(1)/no-drupal/Dockerfile.tpl";
	@DRUPAL_TAG="$(1)" envsubst < "./$(1)/selenium/Dockerfile.tpl" > "./$(1)/selenium/Dockerfile";
	@rm -f "./$(1)/selenium/Dockerfile.tpl";
	@DRUPAL_TAG="$(1)" envsubst < "./$(1)/selenium-no-drupal/Dockerfile.tpl" > "./$(1)/selenium-no-drupal/Dockerfile";
	@rm -f "./$(1)/selenium-no-drupal/Dockerfile.tpl";
endef

define clean_build
	@rm -rf ./$(1)/;
endef

build: clean_build file_build

file_build:
	$(call file_build,8.6)
	# $(call file_build,8.7)

clean_build:
	$(call clean_build,8.6)
	# $(call clean_build,8.7)

test: clean-containers run run_tests

run:
	$(call docker_build,drupal8ci_8_6,./8.6/drupal)
	# $(call docker_build,drupal8ci_8_7,./8.7/drupal)

run_tests:
	$(call docker_tests,drupal8ci_8_6)
	# $(call docker_tests,drupal8ci_8_7)

clean: clean-containers clean-images

clean-containers:
	$(call docker_clean,drupal8ci_8_6)
	# $(call docker_clean,drupal8ci_8_7)

clean-images:
	-docker rmi drupal8ci_8_6;
	# -docker rmi drupal8ci_8_7;

.PHONY: test clean build run