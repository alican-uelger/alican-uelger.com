HUGO_BIN=hugo

.PHONY: build demo genGitHubProjects

genProjects:
	export GITHUB_USER="alican-uelger" && \
	./build/genProjects.sh

build: genProjects
	$(HUGO_BIN)

deploy-build:
	$(HUGO_BIN)

demo:
	$(HUGO_BIN) server -D
