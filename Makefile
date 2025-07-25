include config.mk

SRC = libtcmd.c
OBJ = ${SRC:.c=.o}
SO = ${SRC:.c=.so}
h = ${SRC:.c=.h}
all: libtcmd

.c.o:
	${CC} -c -fPIC ${CFLAGS} $<

${OBJ}: config.mk

libtcmd: ${OBJ}
	${CC} -shared -Wl,-soname,libtcmd.so.${MVERSION} -o ${SO} ${OBJ} ${LDFLAGS}

clean:
	rm -f libtcmd.so ${OBJ} libtcmd-${VERSION}.tar.gz ;
test: ${OBJ}
	${CC} -o $@ ${OBJ} -pedantic -Wall -Wno-deprecated-declarations -O0 -g ${LDFLAGS}
	
dist: clean
	mkdir -p libtcmd-${VERSION}
	cp -R LICENSE Makefile README.md config.mk\
		 ${SRC} ${h} libtcmd-${VERSION}
	tar -cf libtcmd-${VERSION}.tar libtcmd-${VERSION}
	gzip libtcmd-${VERSION}.tar
	rm -rf libtcmd-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/lib
	cp -f libtcmd.so ${DESTDIR}${PREFIX}/lib/libhpd.so.${VERSION}
	link ${DESTDIR}${PREFIX}/lib/libtcmd.so.${VERSION} ${DESTDIR}${PREFIX}/lib/libtcmd.so
	link ${DESTDIR}${PREFIX}/lib/libtcmd.so.${VERSION} ${DESTDIR}${PREFIX}/lib/libtcmd.so.${MVERSION}

uninstall:
	rm -f ${DESTDIR}${PREFIX}/lib/libtcmd.so.${VERSION}

.PHONY: all clean dist install uninstall
