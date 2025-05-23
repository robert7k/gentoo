# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit webapp

DESCRIPTION="Lightweight CalDAV+CardDAV server"
HOMEPAGE="https://sabre.io/baikal/"
SRC_URI="https://github.com/sabre-io/Baikal/releases/download/${PV}/${P}.zip"

S=${WORKDIR}/${PN}
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~ppc64 ~riscv"
IUSE="+mysql sqlite"
REQUIRED_USE="|| ( mysql sqlite )"

DEPEND="app-arch/unzip"
RDEPEND="
	>=dev-lang/php-8.1[ctype,filter,json(+),pdo,session,xml,xmlreader,xmlwriter,mysql?,sqlite?]
	mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite )
	virtual/httpd-php
"

src_install() {
	webapp_src_preinst

	dodoc *.md

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r html/* html/.htaccess Core vendor

	einfo "Setting up container for configuration"
	dodir /etc/${PN}
	fperms o+x /etc/${PN}  # allow webserver to read config

	# setup config in /etc
	# we are not allowed to use straight-forward absolute symlink :(
	local root path htdocsdir=${MY_HTDOCSDIR%/}
	while [[ -n ${htdocsdir} ]] ; do
		root+="../"
		htdocsdir=${htdocsdir%/*}
		# trim duplicate slashes
		while [[ ${htdocsdir} == */ ]] ; do
			htdocsdir=${htdocsdir%/}
		done
	done
	dosym ${root%/}/etc/${PN} "${MY_HTDOCSDIR}"/Specific
	dosym ${root%/}/etc/${PN} "${MY_HTDOCSDIR}"/config
	dosym . "${MY_HTDOCSDIR}"/html

	webapp_postinst_txt en "${FILESDIR}/postinstall-v0.7-en.txt"
	webapp_src_install
}
