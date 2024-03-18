# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Include custom values from .cafenv. Repository root is assumed to be the working directory.
# Including overriding values in this file is preferred over modifying the contents below.
LCAF_ENV_FILE = .lcafenv
-include $(LCAF_ENV_FILE)

# Source repository for repo manifests
REPO_MANIFESTS_URL ?= https://github.com/nexient-llc/launch-common-automation-framework.git
# Branch of source repository for repo manifests. Other tags not currently supported.
REPO_BRANCH ?= refs/tags/0.3.0
# Path to seed manifest in repository referenced in REPO_MANIFESTS_URL
REPO_MANIFEST ?= manifests/terraform_modules/seed/manifest.xml

# Settings to pull in Nexient version of (google) repo utility that supports environment substitution:
REPO_URL ?= https://github.com/nexient-llc/git-repo.git
# Branch of the repository referenced by REPO_URL to use
REPO_REV ?= main
export REPO_REV REPO_URL

# Example variable to substituted after init, but before sync in repo manifests.
GITBASE ?= https://github.com/nexient-llc/
GITREV ?= main
export GITBASE GITREV

# Set to true in a pipeline context
IS_PIPELINE ?= false

IS_AUTHENTICATED ?= false

JOB_NAME ?= job
JOB_EMAIL ?= job@job.job

COMPONENTS_DIR = components
-include $(COMPONENTS_DIR)/Makefile

MODULE_DIR ?= ${COMPONENTS_DIR}/module

PYTHON3_INSTALLED = $(shell which python3 > /dev/null 2>&1; echo $$?)
MISE_INSTALLED = $(shell which mise > /dev/null 2>&1; echo $$?)
ASDF_INSTALLED = $(shell which asdf > /dev/null 2>&1; echo $$?)
REPO_INSTALLED = $(shell which repo > /dev/null 2>&1; echo $$?)
GIT_USER_SET = $(shell git config --get user.name > /dev/null 2>&1; echo $$?)
GIT_EMAIL_SET = $(shell git config --get user.name > /dev/null 2>&1; echo $$?)

.PHONY: configure-git-hooks
configure-git-hooks: configure-dependencies
ifeq ($(PYTHON3_INSTALLED), 0)
	pre-commit install
else
	$(error Missing python3, which is required for pre-commit. Install python3 and rerun.)
endif

ifeq ($(IS_PIPELINE),true)
.PHONY: git-config
git-config:
	@set -ex; \
	git config --global user.name "$(JOB_NAME)"; \
	git config --global user.email "$(JOB_EMAIL)"; \
	git config --global color.ui false

configure: git-config
endif

ifeq ($(IS_AUTHENTICATED),true)
.PHONY: git-auth
git-auth:
	$(call config,Bearer $(GIT_TOKEN))

define config
	@set -ex; \
	git config --global http.extraheader "AUTHORIZATION: $(1)"; \
	git config --global http.https://gerrit.googlesource.com/git-repo/.extraheader ''; \
	git config --global http.version HTTP/1.1;
endef

configure: git-auth
endif

.PHONY: configure-dependencies
configure-dependencies:
ifeq ($(MISE_INSTALLED), 0)
	@echo "Installing dependencies using mise"
	@awk -F'[ #]' '$$NF ~ /https/ {system("mise plugin install " $$1 " " $$NF " --yes")} $$1 ~ /./ {system("mise install " $$1 " " $$2 " --yes")}' ./.tool-versions
else ifeq ($(ASDF_INSTALLED), 0)
	@echo "Installing dependencies using asdf-vm"
	@awk -F'[ #]' '$$NF ~ /https/ {system("asdf plugin add " $$1 " " $$NF)} $$1 ~ /./ {system("asdf plugin add " $$1 "; asdf install " $$1 " " $$2)}' ./.tool-versions
else
	$(error Missing supported dependency manager. Install asdf-vm (https://asdf-vm.com/) or mise (https://mise.jdx.dev/) and rerun)
endif

.PHONY: configure
configure: configure-git-hooks
ifneq ($(and $(GIT_USER_SET), $(GIT_EMAIL_SET)), 0)
	$(error Git identities are not set! Set your user.name and user.email using 'git config' and rerun)
endif
ifeq ($(REPO_INSTALLED), 0)
	echo n | repo --color=never init --no-repo-verify \
		-u "$(REPO_MANIFESTS_URL)" \
		-b "$(REPO_BRANCH)" \
		-m "$(REPO_MANIFEST)"
	repo envsubst
	repo sync
else
	$(error Missing Repo, which is required for platform sync. Install Repo (https://gerrit.googlesource.com/git-repo) and rerun.)
endif

# The first line finds and removes all the directories pulled in by repo
# The second line finds and removes all the broken symlinks from removing things
# https://stackoverflow.com/questions/42828021/removing-files-with-rm-using-find-and-xargs
.PHONY: clean
clean:
	-repo list | awk '{ print $1; }' | cut -d '/' -f1 | uniq | xargs rm -rf
	find . -type l ! -exec test -e {} \; -print | xargs rm -rf

.PHONY: init-clean
init-clean:
	rm -rf .git
	git init --initial-branch=main
ifneq (,$(wildcard ./TEMPLATED_README.md))
	mv TEMPLATED_README.md README.MD
endif
