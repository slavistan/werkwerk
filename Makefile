# TODO(feat): allow PREFIX to be set by user
PREFIX=/usr/local

all:

install: uninstall
	mkdir -p $(PREFIX)/share/werkwerk
	find '.' -maxdepth 1 -mindepth 1 -type d -not -name '\.git' -exec cp -R {} $(PREFIX)/share/werkwerk \;
	mkdir -p $(PREFIX)/bin
	cp -f werkwerk $(PREFIX)/bin
	chmod 755 $(PREFIX)/bin/werkwerk

uninstall:
	rm -rf $(PREFIX)/share/werkwerk
	rm -rf $(PREFIX)/bin/werkwerk

.PHONY: all install uninstall
