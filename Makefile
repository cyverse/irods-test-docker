IRODS_TEST_IMAGE?=cyverse/irods-test
IRODS_TARGET?=4.2.11

.EXPORT_ALL_VARIABLES:

.PHONY: build
build:
	cd irods_$(IRODS_TARGET) && docker-compose build

.PHONY: up
up:
	cd irods_$(IRODS_TARGET) && docker-compose up

.PHONY: down
down:
	cd irods_$(IRODS_TARGET) && docker-compose down
	-docker rm irods_test
	-docker rm irods_db_test

.PHONY: push
push: build
	docker push $(IRODS_TEST_IMAGE):v$(IRODS_TARGET)

.PHONY: clean
clean:
	-docker rm irods_test
	-docker rm irods_db_test
	-docker rmi $(IRODS_TEST_IMAGE):v$(IRODS_TARGET)