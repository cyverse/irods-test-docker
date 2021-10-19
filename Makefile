IRODS_TEST_IMAGE?=cyverse/irods-test

.EXPORT_ALL_VARIABLES:

.PHONY: build
build:
	cd irods_4.2.10 && docker-compose build

.PHONY: up
up:
	cd irods_4.2.10 && docker-compose up

.PHONY: down
down:
	cd irods_4.2.10 && docker-compose down
	-docker rm irods_test
	-docker rm irods_db_test

.PHONY: push
push: build
	docker push $(IRODS_TEST_IMAGE):v4.2.10

.PHONY: clean
clean:
	-docker rm irods_test
	-docker rm irods_db_test
	-docker rmi $(IRODS_TEST_IMAGE)