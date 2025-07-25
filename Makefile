include config.mk

SRC = libtemplate.c
OBJ = ${SRC:.c=.o}
SO = ${SRC:.c=.so}
h = ${SRC:.c=.h}
all: libtemplate

.c.o:
	${CC} -c -fPIC ${CFLAGS} $<

${OBJ}: config.mk

libtemplate: ${OBJ}
	${CC} -shared -Wl,-soname,libtemplate.so.${MVERSION} -o ${SO} ${OBJ} ${LDFLAGS}

clean:
	rm -f libtemplate.so ${OBJ} libtemplate-${VERSION}.tar.gz ;
test: ${OBJ}
	${CC} -o $@ ${OBJ} -pedantic -Wall -Wno-deprecated-declarations -O0 -g ${LDFLAGS}
	
dist: clean
	mkdir -p libtemplate-${VERSION}
	cp -R LICENSE Makefile README.md config.mk\
		 ${SRC} ${h} libtemplate-${VERSION}
	tar -cf libtemplate-${VERSION}.tar libtemplate-${VERSION}
	gzip libtemplate-${VERSION}.tar
	rm -rf libtemplate-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/lib
	cp -f libtemplate.so ${DESTDIR}${PREFIX}/lib/libhpd.so.${VERSION}
	link ${DESTDIR}${PREFIX}/lib/libtemplate.so.${VERSION} ${DESTDIR}${PREFIX}/lib/libtemplate.so
	link ${DESTDIR}${PREFIX}/lib/libtemplate.so.${VERSION} ${DESTDIR}${PREFIX}/lib/libtemplate.so.${MVERSION}

uninstall:
	rm -f ${DESTDIR}${PREFIX}/lib/libtemplate.so.${VERSION}

.PHONY: all clean dist install uninstall
