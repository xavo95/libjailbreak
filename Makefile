TARGET  = libjailbreak.dylib
PREFIX ?= /usr/lib
OUTDIR ?= bin

CC      = xcrun -sdk iphoneos gcc -arch arm64 -arch arm64e
LDID    = ldid

.PHONY: all install clean

all: $(OUTDIR)/$(TARGET)

install: all
	install -d "$(DESTDIR)$(PREFIX)"
	install $(OUTDIR)/$(TARGET) "$(DESTDIR)$(PREFIX)"

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTDIR)/$(TARGET): libjailbreak.m mach/jailbreak_daemonUser.c | $(OUTDIR)
	$(CC) -dynamiclib -install_name "$(PREFIX)/$(TARGET)" -o $@ $^
	$(LDID) -S $@
	tar --disable-copyfile -cvf bin/libjailbreak.dylib.tar -C bin .
	cp bin/libjailbreak.dylib.tar ../../jailbreak-resources/bins/

clean:
	rm -rf $(OUTDIR)
