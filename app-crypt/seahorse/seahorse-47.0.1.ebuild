# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Manage your passwords and encryption keys"
HOMEPAGE="https://gitlab.gnome.org/GNOME/seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="ldap zeroconf"

RDEPEND="
	>=dev-libs/glib-2.66:2
	>=app-crypt/gcr-3.38:0=
	>=app-crypt/gpgme-1.14.0:=
	>=x11-libs/gtk+-3.24.0:3
	>=app-crypt/gnupg-2.2
	>=gui-libs/libhandy-1.6.0:1
	>=app-crypt/libsecret-0.16
	dev-libs/libpwquality
	virtual/openssh
	ldap? ( net-nds/openldap:= )
	net-libs/libsoup:3.0
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/libxml2:2
	app-crypt/gcr:0[vala]
	app-crypt/libsecret[vala]
	gui-libs/libhandy:1[vala]
"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# https://gitlab.gnome.org/GNOME/seahorse/-/issues/348
	"${FILESDIR}/${PN}-47.0.1-ldap-test.patch"
)

src_prepare() {
	default
	vala_setup
	gnome2_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dhelp=true
		-Dpgp-support=true
		-Dcheck-compatible-gpg=false # keep lowest version listed as compatible as min dep for gnupg RDEPEND
		-Dpkcs11-support=true
		-Dkeyservers-support=true
		-Dhkp-support=true
		$(meson_use ldap ldap-support)
		$(meson_use zeroconf key-sharing)
		-Dmanpage=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
