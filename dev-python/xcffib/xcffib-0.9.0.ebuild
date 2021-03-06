# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1 virtualx

DESCRIPTION="A drop in replacement for xpyb, an XCB python binding"
HOMEPAGE="https://github.com/tych0/xcffib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"

DEPEND="x11-libs/libxcb"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]
	' 'python*')
	dev-python/six[${PYTHON_USEDEP}]
	${DEPEND}"
BDEPEND="
	test? (
		x11-apps/xeyes
	)"

distutils_enable_tests nose

PATCHES=( "${FILESDIR}"/${PN}-0.4.2-test-imports.patch )

src_test() {
	virtx distutils-r1_src_test
}
