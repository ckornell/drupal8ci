DRUPAL_STABLE=8.8
DRUPAL_DEV=8.9
DRUPAL_DEV_RELEASE=8.9-beta2
DRUPAL_TEST=9.0
DRUPAL_TEST_RELEASE=9.0-beta2

TPL=tpl/8.x

define prepare
	@echo "Prepare $(3) from ${TPL} for release $(2)..."
	@rm -rf ./$(3)/;
	@cp -r ./${TPL}/ ./$(3)/;
	@IMAGE_TAG="$(1)" RELEASE_TAG="$(2)" DEV_TAG="$(3)" envsubst < "./$(TPL)/drupal/Dockerfile" > "./$(3)/drupal/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/no-drupal/Dockerfile" > "./$(3)/no-drupal/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/no-drupal/composer.json" > "./$(3)/no-drupal/composer.json";
	@echo "...Done!"
endef

prepare:
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_STABLE},${DRUPAL_STABLE})
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_DEV_RELEASE},${DRUPAL_DEV})
	@rm -rf ${DRUPAL_DEV}/no-drupal
ifeq "${DRUPAL_TEST}" ""
	@echo "[[ Skipping test ]]"
else
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_TEST_RELEASE},${DRUPAL_TEST})
	@rm -rf ${DRUPAL_TEST}/no-drupal
endif

.PHONY: prepare