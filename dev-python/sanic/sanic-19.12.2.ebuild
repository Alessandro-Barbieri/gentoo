# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Async Python 3.6+ web server/framework | Build fast. Run fast."
HOMEPAGE="
	https://pypi.python.org/pypi/sanic
	https://github.com/huge-success/sanic
"
SRC_URI="https://github.com/huge-success/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/aiofiles[${PYTHON_USEDEP}]
	~dev-python/httpx-0.9.3[${PYTHON_USEDEP}]
	>=dev-python/httptools-0.0.10[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	<dev-python/multidict-5.0[${PYTHON_USEDEP}]
	dev-python/uvloop[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
	>=dev-python/websockets-7.0[${PYTHON_USEDEP}]
	<dev-python/websockets-9.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		>=dev-python/sphinx-2.1.2[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.5.0[${PYTHON_USEDEP}]

	)
	test? (
		dev-python/beautifulsoup[${PYTHON_USEDEP}]
		dev-python/httpcore[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/pytest-sanic[${PYTHON_USEDEP}]
		dev-python/pytest-sugar[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.rst SECURITY.md README.rst )

distutils_enable_tests pytest
distutils_enable_sphinx docs
