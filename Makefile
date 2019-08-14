define docker_build
	docker build --compress --tag $(1) $(2);
endef

define docker_clean
	-docker stop $(1);
	-docker rm $(1);
endef

define docker_tests
	docker run --rm -t $(1) /scripts/run-tests.sh
endef

define push_gitlab
	docker logout
	docker login -u mog33 registry.gitlab.com
	docker tag $(1) registry.gitlab.com/mog33/drupal8ci/drupal8ci:$(2)
	docker push registry.gitlab.com/mog33/drupal8ci/drupal8ci:$(2)
endef

define push_docker
	docker tag $(1) mogtofu33/drupal8ci:$(2)
	docker push mogtofu33/drupal8ci:$(2)
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

define file_prepare_dev
	@cp -r ./8.x-dev/ ./$(1)/;
	@DRUPAL_DEV_TAG="$(1)" DRUPAL_TAG="$(2)" envsubst < "./$(1)/drupal/Dockerfile.tpl" > "./$(1)/drupal/Dockerfile";
	@rm -f "./$(1)/drupal/Dockerfile.tpl";
	@DRUPAL_DEV_TAG="$(1)" DRUPAL_TAG="$(1)" envsubst < "./$(1)/selenium/Dockerfile.tpl" > "./$(1)/selenium/Dockerfile";
	@rm -f "./$(1)/selenium/Dockerfile.tpl";
endef

define clean_prepare
	@rm -rf ./$(1)/;
endef

prepare: clean_prepare file_prepare

file_prepare:
	$(call file_prepare,8.7)
	$(call file_prepare_dev,8.8.x-dev,8.7)

clean_prepare:
	$(call clean_prepare,8.7)
	$(call clean_prepare,8.8.x-dev)

test: clean-containers build build_tests

build:
	$(call docker_build,drupal8ci_8_7,./8.7/drupal)
	$(call docker_build,drupal8ci_8_7-no-drupal,./8.7/no-drupal)
	$(call docker_build,drupal8ci_8_7-selenium,./8.7/selenium)
	$(call docker_build,drupal8ci_8_7-selenium-no-drupal,./8.7/selenium-no-drupal)
	$(call docker_build,drupal8ci_8_8-dev,./8.8.x-dev/drupal)
	$(call docker_build,drupal8ci_8_8-dev-selenium,./8.8.x-dev/selenium)

build_tests:
	$(call docker_tests,drupal8ci_8_7)
	$(call docker_tests,drupal8ci_8_7-no-drupal)
	$(call docker_tests,drupal8ci_8_7-selenium)
	$(call docker_tests,drupal8ci_8_7-selenium-no-drupal)
	$(call docker_tests,drupal8ci_8_8-dev)
	$(call docker_tests,drupal8ci_8_8-dev-selenium)

push:
	docker logout
	docker login -u mogtofu33
	$(call push_docker,drupal8ci_8_7,8.7)
	$(call push_docker,drupal8ci_8_7-no-drupal,8.7-no-drupal)
	$(call push_docker,drupal8ci_8_7-selenium,8.7-selenium)
	$(call push_docker,drupal8ci_8_7-selenium-no-drupal,8.7-selenium-no-drupal)
	$(call push_docker,drupal8ci_8_8-dev,8.8-dev)
	$(call push_docker,drupal8ci_8_8-dev-selenium,8.8-dev-selenium)
	docker logout

release: clean build build_tests push

clean: clean-containers clean-images

clean-containers:
	$(call docker_clean,drupal8ci_8_7)
	$(call docker_clean,drupal8ci_8_7-no-drupal)
	$(call docker_clean,drupal8ci_8_7-selenium)
	$(call docker_clean,drupal8ci_8_7-selenium-no-drupal)
	$(call docker_clean,drupal8ci_8_8-dev)
	$(call docker_clean,drupal8ci_8_8-dev-selenium)

clean-images:
	-docker rmi drupal8ci_8_7;
	-docker rmi drupal8ci_8_7-no-drupal;
	-docker rmi drupal8ci_8_7-selenium;
	-docker rmi drupal8ci_8_7-selenium-no-drupal;
	-docker rmi drupal8ci_8_8-dev;
	-docker rmi drupal8ci_8_8-dev-selenium;

.PHONY: test clean prepare build run push release