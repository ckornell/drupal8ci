DRUPAL_STABLE=8.8
DRUPAL_DEV=8.9
DRUPAL_TEST=9.0

TPL=tpl/8.x

define prepare
	@echo "Prepare $(2) from ${TPL}..."
	@cp -r ./${TPL}/ ./$(2)/;
	@IMAGE_TAG="$(1)" RELEASE_TAG="$(2)" envsubst < "./$(TPL)/drupal/Dockerfile" > "./$(2)/drupal/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/no-drupal/Dockerfile" > "./$(2)/no-drupal/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/no-drupal/composer.json" > "./$(2)/no-drupal/composer.json";
	@echo "...Done!"
endef

define clean
	-rm -rf ./$(1)/;
endef

prepare: files_clean files_prepare

files_prepare:
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_STABLE})
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_DEV})
	@rm -rf ${DRUPAL_DEV}/no-drupal
ifeq "${DRUPAL_TEST}" ""
	@echo "[[ Skipping test ]]"
else
	$(call prepare,${DRUPAL_STABLE},${DRUPAL_TEST})
	@rm -rf ${DRUPAL_TEST}/no-drupal
endif

files_clean:
	$(call clean,${DRUPAL_STABLE})
	$(call clean,${DRUPAL_DEV})
ifeq "${DRUPAL_TEST}" ""
else
	$(call clean,${DRUPAL_TEST})
endif

.PHONY: prepare