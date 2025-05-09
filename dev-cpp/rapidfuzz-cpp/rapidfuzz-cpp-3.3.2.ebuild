# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Rapid fuzzy string matching in C++"
HOMEPAGE="https://github.com/rapidfuzz/rapidfuzz-cpp/"
SRC_URI="
	https://github.com/rapidfuzz/rapidfuzz-cpp/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=dev-cpp/catch-2
	)
"

src_configure() {
	local mycmakeargs=(
		-DRAPIDFUZZ_BUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
