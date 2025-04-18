# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="C implementation of the Varlink protocol and command line tool"
HOMEPAGE="https://github.com/varlink/libvarlink"
SRC_URI="https://github.com/varlink/libvarlink/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT+=" test"

BDEPEND="virtual/pkgconfig"
