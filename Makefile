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

define file_prepare
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

define clean_prepare
	@rm -rf ./$(1)/;
endef

prepare: clean_prepare file_prepare

file_prepare:
	$(call file_prepare,8.6)

clean_prepare:
	$(call clean_prepare,8.6)

test: clean-containers build build_tests

build:
	$(call docker_build,drupal8ci_8_6,./8.6/drupal)

build_tests:
	$(call docker_tests,drupal8ci_8_6)

clean: clean-containers clean-images

clean-containers:
	$(call docker_clean,drupal8ci_8_6)

clean-images:
	-docker rmi drupal8ci_8_6;

.PHONY: test clean prepare build run