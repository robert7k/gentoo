# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple pager docklet for the WindowMaker window manager"
HOMEPAGE="https://wmpager.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/wmpager/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i "s:\(WMPAGER_DEFAULT_INSTALL_DIR \).*:\1\"/usr/share/wmpager\":" \
		src/wmpager.c || die

	#Honour Gentoo CC, CFLAGS and LDFLAGS, see bug #337604 and #726286
	sed -i -e "s/-g/\${CFLAGS}/" \
		-e "s/\${LIBS}/\${LIBS} \${LDFLAGS}/" \
		-e "s/gcc/\$(CC)/" \
		src/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake INSTALLDIR="${ED}/usr" install
	rm -rf "${ED}"/usr/man || die
	doman man/man1/*.1x
	dodoc README
}
