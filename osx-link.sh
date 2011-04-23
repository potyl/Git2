#!/bin/sh

env MACOSX_DEPLOYMENT_TARGET=10.6 cc \
  -L/opt/local/lib \
  -arch x86_64 \
  -bundle \
  -undefined dynamic_lookup \
  -fstack-protector \
  xs/*.o git2-perl.o \
  -o blib/arch/auto/Git2/Git2.bundle \
  -lgit2

