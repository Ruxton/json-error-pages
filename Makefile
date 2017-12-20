NAME=json-error-pages
NUMVERSION=0.0.2
MINVERSION=`date -u +%Y%m%d%.H%M%S`
OUTDIR=pkg/$(VERSION)
OUTPATH=$(OUTDIR)/$(NAME)

all: build
build: VERSION=$(NUMVERSION)
run: VERSION=$(NUMVERSION)-DEV-$(MINVERSION)
deb: TMPPKGDIR=/tmp/tmpPackageDir
		 VERSION?=$(NUMVERSION)


build: deb

deb:
	@mkdir -p $(OUTDIR)
	@trap 'rm -r ${TMPPKGDIR}' 0 1 2 3 15
	@mkdir -p $(TMPPKGDIR)/DEBIAN
	@cp -R $(OUTDIR)/../../DEBIAN/* $(TMPPKGDIR)/DEBIAN/
	@trap 'rm -f tmpfile' 0 1 2 3 15
	@( echo 'cat <<END_OF_TEXT' && cat $(OUTDIR)/../../DEBIAN/control && echo 'END_OF_TEXT' ) > tmpfile
	@VERSION=${VERSION} source tmpfile > $(TMPPKGDIR)/DEBIAN/control
	@mkdir -p $(TMPPKGDIR)/etc/haproxy/errors/
	@cp *.json $(TMPPKGDIR)/etc/haproxy/errors/
	@dpkg -b $(TMPPKGDIR) $(OUTPATH).deb
