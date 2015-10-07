NAME := selenium
VERSION := $(or $(VERSION),$(VERSION),'2.47.1')
PLATFORM := $(shell uname -s)

all: hub firefox firefoxdebug standalone_firefox standalone_debug_firefox

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_firefox \
	generate_firefoxdebug \
	generate_standalone_firefox \
	generate_standalone_debug_firefox \

build: all

ci: build test

base:
	cd ./Base && docker build -t $(NAME)/base:$(VERSION) .

generate_hub:
	cd ./Hub && ./generate.sh $(VERSION)

hub: base generate_hub
	cd ./Hub && docker build -t $(NAME)/hub:$(VERSION) .

generate_nodebase:
	cd ./NodeBase && ./generate.sh $(VERSION)

nodebase: base generate_nodebase
	cd ./NodeBase && docker build -t $(NAME)/node-base:$(VERSION) .

generate_firefox:
		cd ./NodeFirefox && ./generate.sh $(VERSION)

firefox: nodebase generate_firefox
	cd ./NodeFirefox && docker build -t $(NAME)/node-firefox:$(VERSION) .

generate_standalone_firefox:
	cd ./Standalone && ./generate.sh StandaloneFirefox node-firefox Firefox $(VERSION)

standalone_firefox: generate_standalone_firefox firefox
	cd ./StandaloneFirefox && docker build -t $(NAME)/standalone-firefox:$(VERSION) .

generate_standalone_debug_firefox:
	cd ./StandaloneDebug && ./generate.sh StandaloneDebugFirefox standalone-firefox Firefox $(VERSION)

standalone_debug_firefox: generate_standalone_debug_firefox standalone_firefox
	cd ./StandaloneDebugFirefox && docker build -t $(NAME)/standalone-firefox-debug:$(VERSION) .

generate_firefoxdebug:
	cd ./NodeDebug && ./generate.sh NodeFirefoxDebug node-firefox Firefox $(VERSION)

firefoxdebug: generate_firefoxdebug firefox
	cd ./NodeFirefoxDebug && docker build -t $(NAME)/node-firefox-debug:$(VERSION) .

tag_latest:
	docker tag $(NAME)/base:$(VERSION) $(NAME)/base:latest
	docker tag $(NAME)/hub:$(VERSION) $(NAME)/hub:latest
	docker tag $(NAME)/node-base:$(VERSION) $(NAME)/node-base:latest
	docker tag $(NAME)/node-firefox:$(VERSION) $(NAME)/node-firefox:latest
	docker tag $(NAME)/standalone-firefox:$(VERSION) $(NAME)/standalone-firefox:latest
	docker tag $(NAME)/standalone-firefox-debug:$(VERSION) $(NAME)/standalone-firefox-debug:latest

release: tag_latest
	@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/standalone-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/standalone-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/standalone-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/standalone-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)/base
	docker push $(NAME)/hub
	docker push $(NAME)/node-base
	docker push $(NAME)/node-firefox
	docker push $(NAME)/standalone-firefox
	docker push $(NAME)/standalone-firefox-debug
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

test:
	./test.sh
	./sa-test.sh
	./test.sh debug
	./sa-test.sh debug

.PHONY: \
	all \
	base \
	build \
	chrome \
	chromedebug \
	ci \
	firefox \
	firefoxdebug \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_firefox \
	generate_firefoxdebug \
	generate_standalone_firefox \
	generate_standalone_debug_firefox \
	hub \
	nodebase \
	release \
	standalone_firefox \
	standalone_debug_firefox \
	tag_latest \
	test
