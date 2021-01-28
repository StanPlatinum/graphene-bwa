THIS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
APP_DIR ?= .
APP_NAME = bwa

#################################

.PHONY: all
all: $(APP_NAME).manifest $(APP_NAME) pal_loader
ifeq ($(SGX),1)
all: $(APP_NAME).token
endif

#########################################################################

CC=			gcc
# CC=			clang --analyze
BWA_CFLAGS=		-g -Wall -Wno-unused-function -O2
# CFLAGS=		-g -Wall -Wno-unused-function -O2


WRAP_MALLOC=-DUSE_MALLOC_WRAPPERS
AR=			ar
DFLAGS=		-DHAVE_PTHREAD $(WRAP_MALLOC)
LOBJS=		utils.o kthread.o kstring.o ksw.o bwt.o bntseq.o bwa.o bwamem.o bwamem_pair.o bwamem_extra.o malloc_wrap.o \
			QSufSort.o bwt_gen.o rope.o rle.o is.o bwtindex.o
AOBJS=		bwashm.o bwase.o bwaseqio.o bwtgap.o bwtaln.o bamlite.o \
			bwape.o kopen.o pemerge.o maxk.o \
			bwtsw2_core.o bwtsw2_main.o bwtsw2_aux.o bwt_lite.o \
			bwtsw2_chain.o fastmap.o bwtsw2_pair.o
PROG=		bwa
INCLUDES=	
LIBS=		-lm -lz -lpthread
SUBDIRS=	.

ifeq ($(shell uname -s),Linux)
	LIBS += -lrt
endif

.SUFFIXES:.c .o .cc

.c.o:
		$(CC) -c $(BWA_CFLAGS) $(DFLAGS) $(INCLUDES) $< -o $@

#########################################################################

#################################
# Compile bwa

bwa:libbwa.a $(AOBJS) main.o
		$(CC) $(CFLAGS) $(DFLAGS) $(AOBJS) main.o -o $@ -L. -lbwa $(LIBS)

bwamem-lite:libbwa.a example.o
		$(CC) $(CFLAGS) $(DFLAGS) example.o -o $@ -L. -lbwa $(LIBS)

libbwa.a:$(LOBJS)
		$(AR) -csru $@ $(LOBJS)

clean-bwa:
		rm -f gmon.out *.o a.out $(PROG) *~ *.a

depend:
	( LC_ALL=C ; export LC_ALL; makedepend -Y -- $(CFLAGS) $(DFLAGS) -- *.c )

# DO NOT DELETE THIS LINE -- make depend depends on it.

QSufSort.o: QSufSort.h
bamlite.o: bamlite.h malloc_wrap.h
bntseq.o: bntseq.h utils.h kseq.h malloc_wrap.h khash.h
bwa.o: bntseq.h bwa.h bwt.h ksw.h utils.h kstring.h malloc_wrap.h kvec.h
bwa.o: kseq.h
bwamem.o: kstring.h malloc_wrap.h bwamem.h bwt.h bntseq.h bwa.h ksw.h kvec.h
bwamem.o: ksort.h utils.h kbtree.h
bwamem_extra.o: bwa.h bntseq.h bwt.h bwamem.h kstring.h malloc_wrap.h
bwamem_pair.o: kstring.h malloc_wrap.h bwamem.h bwt.h bntseq.h bwa.h kvec.h
bwamem_pair.o: utils.h ksw.h
bwape.o: bwtaln.h bwt.h kvec.h malloc_wrap.h bntseq.h utils.h bwase.h bwa.h
bwape.o: ksw.h khash.h
bwase.o: bwase.h bntseq.h bwt.h bwtaln.h utils.h kstring.h malloc_wrap.h
bwase.o: bwa.h ksw.h
bwaseqio.o: bwtaln.h bwt.h utils.h bamlite.h malloc_wrap.h kseq.h
bwashm.o: bwa.h bntseq.h bwt.h
bwt.o: utils.h bwt.h kvec.h malloc_wrap.h
bwt_gen.o: QSufSort.h malloc_wrap.h
bwt_lite.o: bwt_lite.h malloc_wrap.h
bwtaln.o: bwtaln.h bwt.h bwtgap.h utils.h bwa.h bntseq.h malloc_wrap.h
bwtgap.o: bwtgap.h bwt.h bwtaln.h malloc_wrap.h
bwtindex.o: bntseq.h bwa.h bwt.h utils.h rle.h rope.h malloc_wrap.h
bwtsw2_aux.o: bntseq.h bwt_lite.h utils.h bwtsw2.h bwt.h kstring.h
bwtsw2_aux.o: malloc_wrap.h bwa.h ksw.h kseq.h ksort.h
bwtsw2_chain.o: bwtsw2.h bntseq.h bwt_lite.h bwt.h malloc_wrap.h ksort.h
bwtsw2_core.o: bwt_lite.h bwtsw2.h bntseq.h bwt.h kvec.h malloc_wrap.h
bwtsw2_core.o: khash.h ksort.h
bwtsw2_main.o: bwt.h bwtsw2.h bntseq.h bwt_lite.h utils.h bwa.h
bwtsw2_pair.o: utils.h bwt.h bntseq.h bwtsw2.h bwt_lite.h kstring.h
bwtsw2_pair.o: malloc_wrap.h ksw.h
example.o: bwamem.h bwt.h bntseq.h bwa.h kseq.h malloc_wrap.h
fastmap.o: bwa.h bntseq.h bwt.h bwamem.h kvec.h malloc_wrap.h utils.h kseq.h
is.o: malloc_wrap.h
kopen.o: malloc_wrap.h
kstring.o: kstring.h malloc_wrap.h
ksw.o: ksw.h malloc_wrap.h
main.o: kstring.h malloc_wrap.h utils.h
malloc_wrap.o: malloc_wrap.h
maxk.o: bwa.h bntseq.h bwt.h bwamem.h kseq.h malloc_wrap.h
pemerge.o: ksw.h kseq.h malloc_wrap.h kstring.h bwa.h bntseq.h bwt.h utils.h
rle.o: rle.h
rope.o: rle.h rope.h
utils.o: utils.h ksort.h malloc_wrap.h kseq.h

#########################################################################

# Use one of these commands to build the manifest for your app:
#
# - make
# - make DEBUG=1
# - make SGX=1
# - make SGX=1 DEBUG=1
#
# Use `make clean` to remove Graphene-generated files.

# Relative path to Graphene root
GRAPHENEDIR ?= $(THIS_DIR)../..
SGX_SIGNER_KEY ?= $(GRAPHENEDIR)/Pal/src/host/Linux-SGX/signer/enclave-key.pem


ifeq ($(DEBUG),1)
GRAPHENEDEBUG = inline
else
GRAPHENEDEBUG = none
endif

include $(GRAPHENEDIR)/Scripts/Makefile.configs

# $(APP_NAME) dependencies (generated from ldd). For SGX, the manifest needs to list all the libraries
# loaded during execution, so that the signer can include the file hashes.

# We need to replace Glibc dependencies with Graphene-specific Glibc. The Glibc binaries are
# already listed in the manifest template, so we can skip them from the ldd results.
# GLIBC_DEPS = linux-vdso.so.1 /lib64/ld-linux-x86-64.so.2 libc.so.6 libpthread.so.0
GLIBC_DEPS = linux-vdso.so.1 

# List all the $(APP_NAME) dependencies, besides Glibc libraries
.INTERMEDIATE: $(APP_NAME)-deps
$(APP_NAME)-deps: $(APP_NAME)
	@echo $(patsubst %,-e %,$(GLIBC_DEPS))
	# @ldd $(APP_DIR)/$(APP_NAME) | \
	# 	awk '{if ($$2 =="=>") {print $$1}}' | \
	# 	sort | uniq | grep -v -x $(patsubst %,-e %,$(GLIBC_DEPS)) > $@
	@ldd $(APP_DIR)/$(APP_NAME) | \
		awk '{if ($$2 =="=>") {print $$1}}' | \
		sort | uniq | grep -v -x $(patsubst %,-e %,$(GLIBC_DEPS)) > $@

# Generate manifest rules for $(APP_NAME) dependencies
.INTERMEDIATE: $(APP_NAME)-trusted-libs
$(APP_NAME)-trusted-libs: $(APP_NAME)-deps
	@for F in `cat $(APP_NAME)-deps`; do \
		P=`ldd $(APP_DIR)/$(APP_NAME) | grep $$F | awk '{print $$3; exit}'`; \
		N=`echo $$F | tr --delete '.' | tr --delete '-'`; \
		echo -n "sgx.trusted_files.$$N = \\\"file:$$P\\\"\\\\n"; \
	done > $@

$(APP_NAME).manifest: $(APP_NAME).manifest.template $(APP_NAME)-trusted-libs
	@sed -e 's|$$(GRAPHENEDIR)|'"$(GRAPHENEDIR)"'|g' \
		-e 's|$$(GRAPHENEDEBUG)|'"$(GRAPHENEDEBUG)"'|g' \
		-e 's|$$(APP_DIR)|'"$(APP_DIR)"'|g' \
		-e 's|$$(APP_TRUSTED_LIBS)|'"`cat $(APP_NAME)-trusted-libs`"'|g' \
		-e 's|$$(ARCH_LIBDIR)|'"$(ARCH_LIBDIR)"'|g' \
		$< > $@

# Generate SGX-specific manifest, enclave signature, and token for enclave initialization
$(APP_NAME).manifest.sgx: $(APP_NAME) $(APP_NAME).manifest
	$(GRAPHENEDIR)/Pal/src/host/Linux-SGX/signer/pal-sgx-sign \
		-exec $(APP_NAME) \
		-libpal $(GRAPHENEDIR)/Runtime/libpal-Linux-SGX.so \
		-key $(SGX_SIGNER_KEY) \
		-manifest $(APP_NAME).manifest -output $@

$(APP_NAME).sig: $(APP_NAME).manifest.sgx

$(APP_NAME).token: $(APP_NAME).sig
	$(GRAPHENEDIR)/Pal/src/host/Linux-SGX/signer/pal-sgx-get-token \
		-output $@ -sig $^


#################################
# Extra executables
pal_loader:
	ln -s $(GRAPHENEDIR)/Runtime/pal_loader $@

#################################
# Run executablese

run-nonsgx:
	./bwa index data/genome.fa
	./bwa mem data/genome.fa data/ecoli.4k.fastq

run-sgx: bwa.manifest.sgx
	./bwa index data/genome.fa
	SGX=1 ./pal_loader bwa mem data/genome.fa data/ecoli.4k.fastq

.PHONY: clean-bwa clean-sgx clean-data clean-all

clean-sgx:
	$(RM) *.manifest *.manifest.sgx *.token *.sig pal_loader

clean-data:
	$(RM) data/genome.fa.*

clean-all: clean-bwa clean-sgx clean-data
