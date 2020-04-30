DRUPAL_STABLE=8.8
DRUPAL_DEV=8.9
DRUPAL_DEV_RELEASE=8.9-beta2
DRUPAL_TEST=9.0
DRUPAL_TEST_RELEASE=9.0-beta2
RELEASE=2.x-dev

TPL=tpl

define prepare
	@echo "Prepare $(3) from ${TPL} for release $(2)..."
	@rm -rf ./$(3)/;
	@cp -r ./${TPL}/ ./$(3)/;
	@RELEASE="$(RELEASE)" IMAGE_TAG="$(1)" RELEASE_TAG="$(2)" DEV_TAG="$(3)" envsubst < "./$(TPL)/drupal/Dockerfile" > "./$(3)/drupal/Dockerfile";
	@RELEASE="$(RELEASE)" IMAGE_TAG="$(1)" envsubst < "./$(TPL)/base/Dockerfile" > "./$(3)/base/Dockerfile";
	@RELEASE="$(RELEASE)" IMAGE_TAG="$(1)" envsubst < "./$(TPL)/base/composer.json" > "./$(3)/base/composer.json";
	@echo "...Done!"
endef

prepare:
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_STABLE},${DRUPAL_STABLE})
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_DEV_RELEASE},${DRUPAL_DEV})
	@rm -rf ${DRUPAL_DEV}/base
ifeq "${DRUPAL_TEST}" ""
	@echo "[[ Skipping test ]]"
else
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_TEST_RELEASE},${DRUPAL_TEST})
	@rm -rf ${DRUPAL_TEST}/base
endif

.PHONY: prepare