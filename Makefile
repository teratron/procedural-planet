
set-url: ## git remote set-url origin git@github.com:login/repo.git
	git remote set-url origin git@github.com:teratron/procedural-planet.git

message = Lesson #2
branch = master
add-commit-push: ## add commit push
	git add .
	git commit -m "$(message)"
	git push origin $(branch)

.PHONY: help
help:
	@awk '                                             \
		BEGIN {FS = ":.*?## "}                         \
		/^[a-zA-Z_-]+:.*?## /                          \
		{printf "\033[36m%-24s\033[0m %s\n", $$1, $$2} \
	'                                                  \
	$(MAKEFILE_LIST)

.DEFAULT_GOAL := help
