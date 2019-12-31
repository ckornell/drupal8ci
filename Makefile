DRUPAL_CURRENT_STABLE=8.8
DRUPAL_CURRENT_DEV=8.9
DRUPAL_CURRENT_DEV_RELEASE=8.9.x-dev
DRUPAL_CURRENT_TEST=
DRUPAL_CURRENT_TEST_RELEASE=

STABLE_TPL=8.x
DEV_TPL=8.x-dev

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
	@echo "Prepare $(1) from ${STABLE_TPL}..."
	@cp -r ./${STABLE_TPL}/ ./$(1)/;
	@DRUPAL_TAG="$(1)" envsubst < "./$(1)/drupal/Dockerfile.tpl" > "./$(1)/drupal/Dockerfile";
	@rm -f "./$(1)/drupal/Dockerfile.tpl";
	@DRUPAL_TAG="$(1)" envsubst < "./$(1)/no-drupal/Dockerfile.tpl" > "./$(1)/no-drupal/Dockerfile";
	@rm -f "./$(1)/no-drupal/Dockerfile.tpl";
	@echo "...Done!"
endef

define file_prepare_dev
	@echo "Prepare $(1) from ${DEV_TPL}..."
	@cp -r ./${DEV_TPL}/ ./$(1)/;
	@cp -r ./${DEV_TPL}/drupal/Dockerfile.tpl ./$(1)/drupal/Dockerfile.tpl;
	@DRUPAL_DOWNLOAD_TAG="$(2)" DRUPAL_TAG="$(3)" envsubst < "./$(1)/drupal/Dockerfile.tpl" > "./$(1)/drupal/Dockerfile";
	@rm -f "./$(1)/drupal/Dockerfile.tpl";
	@echo "...Done!"
endef

define clean_prepare
	-rm -rf ./$(1)/;
endef

prepare: clean_prepare file_prepare

file_prepare:
	$(call file_prepare,${DRUPAL_CURRENT_STABLE})
	$(call file_prepare_dev,${DRUPAL_CURRENT_DEV},${DRUPAL_CURRENT_DEV_RELEASE},${DRUPAL_CURRENT_STABLE})
ifeq "${DRUPAL_CURRENT_TEST}" ""
	@echo "Skipping test"
else
	$(call file_prepare_dev,${DRUPAL_CURRENT_TEST},${DRUPAL_CURRENT_TEST_RELEASE},${DRUPAL_CURRENT_STABLE})
endif

clean_prepare:
	$(call clean_prepare,${DRUPAL_CURRENT_STABLE})
	$(call clean_prepare,${DRUPAL_CURRENT_DEV})
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call clean_prepare,${DRUPAL_CURRENT_TEST})
endif

test: clean-containers build build_tests

test_all: clean-containers build_variants build_variants_tests

build:
	$(call docker_build,drupal8ci_${DRUPAL_CURRENT_STABLE},./${DRUPAL_CURRENT_STABLE}/drupal)
	$(call docker_build,drupal8ci_${DRUPAL_CURRENT_DEV},./${DRUPAL_CURRENT_DEV}/drupal)
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call docker_build,drupal8ci_${DRUPAL_CURRENT_TEST},./${DRUPAL_CURRENT_TEST}/drupal)
endif

build_tests:
	$(call docker_tests,drupal8ci_${DRUPAL_CURRENT_STABLE})
	$(call docker_tests,drupal8ci_${DRUPAL_CURRENT_DEV})
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call docker_tests,drupal8ci_${DRUPAL_CURRENT_TEST})
endif

build_variants:
	$(call docker_build,drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal,./${DRUPAL_CURRENT_STABLE}/no-drupal)

build_variants_tests:
	$(call docker_tests,drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal)

push:
	@docker logout
	docker login -u mogtofu33
	$(call push_docker,drupal8ci_${DRUPAL_CURRENT_STABLE},${DRUPAL_CURRENT_STABLE}-drupal)
	$(call push_docker,drupal8ci_${DRUPAL_CURRENT_DEV},${DRUPAL_CURRENT_DEV}-drupal)
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call push_docker,drupal8ci_${DRUPAL_CURRENT_TEST},${DRUPAL_CURRENT_TEST}-drupal)
endif
	docker logout

push_variants:
	@docker logout
	docker login -u mogtofu33
	$(call push_docker,drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal,${DRUPAL_CURRENT_STABLE}-no-drupal)
	$(call push_docker,drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal,${DRUPAL_CURRENT_DEV}-no-drupal)
	# No drupal variant is the same.
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call push_docker,drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal,${DRUPAL_CURRENT_TEST}-no-drupal)
endif
	docker logout

clean: clean-containers clean-images

clean-containers:
	$(call docker_clean,drupal8ci_${DRUPAL_CURRENT_STABLE})
	$(call docker_clean,drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal)
	$(call docker_clean,drupal8ci_${DRUPAL_CURRENT_DEV})
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call docker_clean,drupal8ci_${DRUPAL_CURRENT_TEST})
endif

clean-images:
	-docker rmi drupal8ci_${DRUPAL_CURRENT_STABLE};
	-docker rmi drupal8ci_${DRUPAL_CURRENT_STABLE}-no-drupal;
	-docker rmi drupal8ci_${DRUPAL_CURRENT_DEV};
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	-docker rmi drupal8ci_${DRUPAL_CURRENT_TEST};
endif

dry-release: clean build build_tests build_variants build_variants_tests

push-release: push push_variants

release: clean build build_tests push build_variants build_variants_tests push_variants

.PHONY: test clean prepare build run push release