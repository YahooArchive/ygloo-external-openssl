#
# These flags represent the build-time configuration of OpenSSL for android
#
# The value of $(openssl_cflags) was pruned from the Makefile generated
# by running ./Configure from import_openssl.sh.
#
# This script performs minor but required patching for the Android build.
#

# Directories for ENGINE shared libraries
openssl_cflags_32 += \
  -DOPENSSLDIR="\"/system/lib/ssl\"" \
  -DENGINESDIR="\"/system/lib/ssl/engines\""
openssl_cflags_static_32 += \
  -DOPENSSLDIR="\"/system/lib/ssl\"" \
  -DENGINESDIR="\"/system/lib/ssl/engines\""
openssl_cflags_64 += \
  -DOPENSSLDIR="\"/system/lib64/ssl\"" \
  -DENGINESDIR="\"/system/lib64/ssl/engines\""
openssl_cflags_static_64 += \
  -DOPENSSLDIR="\"/system/lib64/ssl\"" \
  -DENGINESDIR="\"/system/lib64/ssl/engines\""

# Intentionally excluded http://b/7079965
ifneq (,$(filter -DZLIB, $(openssl_cflags_32) $(openssl_cflags_64) \
    $(openssl_cflags_static_32) $(openssl_cflags_static_64)))
$(error ZLIB should not be enabled in openssl configuration)
endif

#LOCAL_CFLAGS_32 += $(openssl_cflags_32)
#LOCAL_CFLAGS_64 += $(openssl_cflags_64)
LOCAL_CFLAGS_32 += $(openssl_cflags_static_32)
LOCAL_CFLAGS_64 += $(openssl_cflags_static_64)

LOCAL_CFLAGS_32 := $(filter-out -DTERMIO, $(LOCAL_CFLAGS_32))
LOCAL_CFLAGS_64 := $(filter-out -DTERMIO, $(LOCAL_CFLAGS_64))
# filter out static flags too
openssl_cflags_static_32 := $(filter-out -DTERMIO, $(openssl_cflags_static_32))
openssl_cflags_static_64 := $(filter-out -DTERMIO, $(openssl_cflags_static_64))

ifeq ($(HOST_OS),windows)
LOCAL_CFLAGS_32 := $(filter-out -DDSO_DLFCN -DHAVE_DLFCN_H,$(LOCAL_CFLAGS_32))
LOCAL_CFLAGS_64 := $(filter-out -DDSO_DLFCN -DHAVE_DLFCN_H,$(LOCAL_CFLAGS_64))
endif

# Debug
# LOCAL_CFLAGS += -DCIPHER_DEBUG

# Add clang here when it works on host
# LOCAL_CLANG := true

ifeq ($(TARGET_ARCH),x86_64)
LOCAL_CFLAGS += $(LOCAL_CFLAGS_64)
else
ifeq ($(TARGET_ARCH),arm64)
LOCAL_CFLAGS += $(LOCAL_CFLAGS_64)
else
LOCAL_CFLAGS += $(LOCAL_CFLAGS_32)
endif
endif

ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS += $(LOCAL_CFLAGS_arm)
LOCAL_SRC_FILES := $(LOCAL_SRC_FILES_arm)
LOCAL_C_INCLUDES += $(LOCAL_C_INCLUDES_arm)
else
#LOCAL_CFLAGS += $(LOCAL_CFLAGS_$(TARGET_ARCH))
#LOCAL_C_INCLUDES += $(LOCAL_C_INCLUDES_$(TARGET_ARCH))
#LOCAL_SRC_FILES := $(LOCAL_SRC_FILES_$(TARGET_ARCH))
LOCAL_SRC_FILES := $(common_src_files)
endif
