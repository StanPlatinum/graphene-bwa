# Use one of these commands to build the manifest for curl:
#
# - make
# - make DEBUG=1
# - make SGX=1
# - make SGX=1 DEBUG=1
#
# Use `make clean` to remove Graphene-generated files.

APP_NAME ?= hello
APP_DIR = /u/weijliu/graphene-bwa/NewNewTemplate

# Relative path to Graphene root and key for enclave signing
GRAPHENEDIR ?= /usr/local/src/graphene
SGX_SIGNER_KEY ?= $(GRAPHENEDIR)/Pal/src/host/Linux-SGX/signer/enclave-key.pem

ifeq ($(DEBUG),1)
GRAPHENE_LOG_LEVEL = debug
else
GRAPHENE_LOG_LEVEL = error
endif

.PHONY: all
all: $(APP_NAME).manifest
ifeq ($(SGX),1)
all: $(APP_NAME).manifest.sgx $(APP_NAME).sig $(APP_NAME).token
endif

include $(GRAPHENEDIR)/Scripts/Makefile.configs

$(APP_NAME).manifest: $(APP_NAME).manifest.template
	graphene-manifest \
		-Dlog_level=$(GRAPHENE_LOG_LEVEL) \
		-Dhome=$(HOME) \
		-Darch_libdir=$(ARCH_LIBDIR) \
		-Dapp_dir=$(APP_DIR) \
		-Dapp_name=$(APP_NAME) \
		$< >$@

# Generate SGX-specific manifest, enclave signature, and token for enclave initialization
$(APP_NAME).manifest.sgx: $(APP_NAME).manifest
	graphene-sgx-sign \
		--key $(SGX_SIGNER_KEY) \
		--manifest $(APP_NAME).manifest \
		--output $@

$(APP_NAME).sig: $(APP_NAME).manifest.sgx

$(APP_NAME).token: $(APP_NAME).sig
	graphene-sgx-get-token --output $@ --sig $^

ifeq ($(SGX),)
GRAPHENE = graphene-direct
else
GRAPHENE = graphene-sgx
endif

.PHONY: check
check: all
	$(GRAPHENE) $(APP_DIR)/$(APP_NAME)

.PHONY: clean
clean:
	$(RM) *.manifest *.manifest.sgx *.token *.sig OUTPUT

.PHONY: distclean
distclean: clean
