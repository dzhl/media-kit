SHELL := /usr/bin/env bash

MPV_XCFRAMEWORKS_VERSION := v1.0.15
MPV_XCFRAMEWORKS_SHA256SUM := 3c367414010d9998a704153d3361d99b01d833aa717903ad52a97506cf830207

all: Frameworks/.stamp_${MPV_XCFRAMEWORKS_VERSION} Frameworks/.symlinks

TAR=tar
TAR_WILDCARDS_FLAG := $(shell ${TAR} --version 2>&1 | grep -q 'GNU' && echo "--wildcards" || echo "")

SED=sed
SED_INPLACE_FLAG := $(shell ${SED} --version 2>&1 | grep -q 'GNU' && echo "" || echo "''")

.cache/xcframeworks/libmpv-xcframeworks-${MPV_XCFRAMEWORKS_VERSION}-ios-universal.tar.gz:
	mkdir -p .cache/xcframeworks
	rm -f .cache/xcframeworks/*.tmp .cache/xcframeworks/*-ios-universal.tar.gz
	curl -L \
		https://github.com/dzhl/libmpv-darwin-build/releases/download/${MPV_XCFRAMEWORKS_VERSION}/libmpv-xcframeworks_${MPV_XCFRAMEWORKS_VERSION}_ios-universal-video-full.tar.gz \
		-o .cache/xcframeworks/libmpv.tar.gz.tmp
	if command -v shasum &> /dev/null; then \
		echo "${MPV_XCFRAMEWORKS_SHA256SUM}  .cache/xcframeworks/libmpv.tar.gz.tmp" | shasum -a 256 -c - || \
		echo "${MPV_XCFRAMEWORKS_SHA256SUM} *.cache/xcframeworks/libmpv.tar.gz.tmp" | shasum -a 256 -c - || \
		(shasum -a 256 .cache/xcframeworks/libmpv.tar.gz.tmp | grep -qi "${MPV_XCFRAMEWORKS_SHA256SUM}"); \
	elif command -v sha256sum &> /dev/null; then \
		echo "${MPV_XCFRAMEWORKS_SHA256SUM}  .cache/xcframeworks/libmpv.tar.gz.tmp" | sha256sum -c - ; \
	elif command -v openssl &> /dev/null; then \
		openssl dgst -sha256 .cache/xcframeworks/libmpv.tar.gz.tmp | grep -qi "${MPV_XCFRAMEWORKS_SHA256SUM}" ; \
	else \
		echo "Warning: No sha256 verification tool found, skipping hash check" ; \
	fi
	mv .cache/xcframeworks/libmpv.tar.gz.tmp .cache/xcframeworks/libmpv-xcframeworks-${MPV_XCFRAMEWORKS_VERSION}-ios-universal.tar.gz
	touch .cache/xcframeworks/libmpv-xcframeworks-${MPV_XCFRAMEWORKS_VERSION}-ios-universal.tar.gz

.cache/xcframeworks/libmpv-xcframeworks-ios-universal.tar.gz: .cache/xcframeworks/libmpv-xcframeworks-${MPV_XCFRAMEWORKS_VERSION}-ios-universal.tar.gz
	rm -f .cache/xcframeworks/libmpv-xcframeworks-ios-universal.tar.gz
	ln -s libmpv-xcframeworks-${MPV_XCFRAMEWORKS_VERSION}-ios-universal.tar.gz .cache/xcframeworks/libmpv-xcframeworks-ios-universal.tar.gz

Frameworks/.stamp_${MPV_XCFRAMEWORKS_VERSION}: .cache/xcframeworks/libmpv-xcframeworks-ios-universal.tar.gz
	mkdir -p Frameworks
	rm -rf Frameworks/*.xcframework Frameworks/.stamp_*
	${TAR} ${TAR_WILDCARDS_FLAG} -xvf .cache/xcframeworks/libmpv-xcframeworks-ios-universal.tar.gz --strip-components 1 -C Frameworks
	touch Frameworks/.stamp_${MPV_XCFRAMEWORKS_VERSION}

Frameworks/.symlinks: Frameworks/.stamp_${MPV_XCFRAMEWORKS_VERSION}
	rm -rf Frameworks/.symlinks
	mkdir -p Frameworks/.symlinks/mpv
	${SED} -i ${SED_INPLACE_FLAG} 's/\r$$//g' create_framework_symlinks.sh # remove CRLF line terminator added by Flutter packaging (https://github.com/media-kit/media-kit/issues/338)
	sh create_framework_symlinks.sh Frameworks/Mpv.xcframework Frameworks/.symlinks/mpv

.PHONY: clean
clean:
	rm -rf .cache
	rm -f ./Headers/mpv/*.h
	rm -rf ./Frameworks/*.xcframework
