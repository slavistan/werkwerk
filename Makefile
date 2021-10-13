# TODO(feat): allow PREFIX to be set by user
PREFIX=/usr/local

all:

install: uninstall
	mkdir -p $(PREFIX)/share/werkwerk
	find '.' -maxdepth 1 -mindepth 1 -type d -not -name '\.git' -exec cp -r {} $(PREFIX)/share/werkwerk \;
	mkdir -p $(PREFIX)/bin
	cp werkwerk $(PREFIX)/bin
	chmod 755 $(PREFIX)/bin/werkwerk

symlink: uninstall
	ln -s "$(shell realpath .)" $(PREFIX)/share
	mkdir -p $(PREFIX)/bin
	ln -s "$(shell realpath werkwerk)" $(PREFIX)/bin

uninstall:
	rm -rf $(PREFIX)/share/werkwerk
	rm -f $(PREFIX)/bin/werkwerk

.PHONY: all install uninstall
