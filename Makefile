# Use one of these commands to build the manifest for curl:
#
# - make
# - make DEBUG=1
# - make SGX=1
# - make SGX=1 DEBUG=1
#
# Use `make clean` to remove Graphene-generated files.

APP_NAME ?= bwa
#WL: must be current abs path
APP_DIR = /u/weijliu/graphene-bwa

# Relative path to Graphene root and key for enclave signing
# GRAPHENEDIR ?= /usr/local/src/graphene
GRAPHENEDIR ?= /usr/local/src/test/graphene

SGX_SIGNER_KEY ?= $(GRAPHENEDIR)/Pal/src/host/Linux-SGX/signer/enclave-key.pem

ifeq ($(DEBUG),1)
GRAPHENE_LOG_LEVEL = debug
else
GRAPHENE_LOG_LEVEL = error
endif

.PHONY: all
all: $(APP_NAME) $(APP_NAME).manifest
ifeq ($(SGX),1)
all: $(APP_NAME) $(APP_NAME).manifest.sgx $(APP_NAME).sig $(APP_NAME).token
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

$(APP_NAME):
	make -C bwa_src
	cp bwa_src/bwa .

.PHONY: run-big
run-big: all
	# ./bwa index data/genome.fa
	$(GRAPHENE) $(APP_NAME) mem data/hg38_reference.fa data/SRR062634.filt.fastq


.PHONY: run-sample
run-sample: all
	# ./bwa index data/genome.fa
	$(GRAPHENE) $(APP_NAME) mem data/genome.fa data/SRR062634.filt.fastq

i = 1
PARTITION = 40

.PHONY: run
run: all
	mkdir /mnt/graphene-dida-bwa/pr/out/
	$(RM) /mnt/graphene-dida-bwa/pr/out/aln-$i.sam
	$(GRAPHENE) $(APP_NAME) mem -k25 -o /mnt/graphene-dida-bwa/pr/out/aln-$i.sam /mnt/graphene-dida-bwa/work/ref_$(PARTITION)/mref-$i.fa /mnt/graphene-dida-bwa/pr/mreads-$i.fa	

.PHONY: clean
clean:
	make -C bwa_src clean 
	$(RM) *.manifest *.manifest.sgx *.token *.sig $(APP_NAME) pal_loader OUTPUT
	$(RM) *-trusted-libs *-deps
.PHONY: distclean
distclean: clean
