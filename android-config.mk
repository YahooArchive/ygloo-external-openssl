#
# These flags represent the build-time configuration of OpenSSL for android
#
# The value of $(openssl_cflags) was pruned from the Makefile generated
# by running ./Configure from import_openssl.sh.
#
# This script performs minor but required patching for the Android build.
#

LOCAL_CFLAGS += $(openssl_cflags)

LOCAL_CFLAGS := $(filter-out -DTERMIO, $(LOCAL_CFLAGS))

LOCAL_CFLAGS := $(filter-out -DDSO_DLFCN -DHAVE_DLFCN_H,$(LOCAL_CFLAGS))

# Directories
LOCAL_CFLAGS += \
  -DOPENSSLDIR="\"/system/lib/ssl\"" \
  -DENGINESDIR="\"/system/lib/ssl/engines\""

# Disable RC4
LOCAL_CFLAGS += -DOPENSSL_NO_RC4=1

ifeq ($(BUILD_DEBUG),true)
LOCAL_CFLAGS += -DPURIFY
endif

# Intentionally excluded http://b/7079965
LOCAL_CFLAGS := $(filter-out -DZLIB, $(LOCAL_CFLAGS))

# Debug
# LOCAL_CFLAGS += -DCIPHER_DEBUG

# Add clang here when it works on host
# LOCAL_CLANG := true
