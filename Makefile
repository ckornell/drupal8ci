DRUPAL_CURRENT_STABLE=8.8
DRUPAL_CURRENT_DEV=8.9
DRUPAL_CURRENT_DEV_RELEASE=8.9.x-dev
DRUPAL_CURRENT_TEST=
DRUPAL_CURRENT_TEST_RELEASE=

STABLE_TPL=8.x
DEV_TPL=8.x-dev

define prepare
	@echo "Prepare $(1) from ${STABLE_TPL}..."
	@cp -r ./${STABLE_TPL}/ ./$(1)/;
	@DRUPAL_TAG="$(1)" envsubst < "./$(STABLE_TPL)/drupal/Dockerfile" > "./$(1)/drupal/Dockerfile";
	@DRUPAL_TAG="$(1)" envsubst < "./$(STABLE_TPL)/no-drupal/Dockerfile" > "./$(1)/no-drupal/Dockerfile";
	@DRUPAL_TAG="$(1)" envsubst < "./$(STABLE_TPL)/no-drupal/composer.json" > "./$(1)/no-drupal/composer.json";
	@echo "...Done!"
endef

define prepare_dev
	@echo "Prepare $(1) from ${DEV_TPL}..."
	@cp -r ./${DEV_TPL}/ ./$(1)/;
	@DRUPAL_CURRENT_DEV="$(1)" DRUPAL_DOWNLOAD_TAG="$(2)" DRUPAL_TAG="$(3)" envsubst < "./$(DEV_TPL)/drupal/Dockerfile" > "./$(1)/drupal/Dockerfile";
	@rm -f "./$(1)/drupal/Dockerfile.tpl";
	@echo "...Done!"
endef

define clean
	-rm -rf ./$(1)/;
endef

prepare: files_clean files_prepare

files_prepare:
	$(call prepare,${DRUPAL_CURRENT_STABLE})
	$(call prepare_dev,${DRUPAL_CURRENT_DEV},${DRUPAL_CURRENT_DEV_RELEASE},${DRUPAL_CURRENT_STABLE})
ifeq "${DRUPAL_CURRENT_TEST}" ""
	@echo "[[ Skipping test ]]"
else
	$(call prepare_dev,${DRUPAL_CURRENT_TEST},${DRUPAL_CURRENT_TEST_RELEASE},${DRUPAL_CURRENT_STABLE})
endif

files_clean:
	$(call clean,${DRUPAL_CURRENT_STABLE})
	$(call clean,${DRUPAL_CURRENT_DEV})
ifeq "${DRUPAL_CURRENT_TEST}" ""
else
	$(call clean,${DRUPAL_CURRENT_TEST})
endif

.PHONY: prepare