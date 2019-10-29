# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A high-performance, parallel remote shell utility"
HOMEPAGE="https://computing.llnl.gov/linux/pdsh.html"
SRC_URI="https://github.com/chaos/pdsh/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt exec genders mrsh netgroup nodeupdown readline rsh slurm ssh test xcpu"
RESTRICT="test? ( userpriv ) !test? ( test )"

RDEPEND="
	crypt?		( net-misc/openssh )
	readline?	( sys-libs/readline:0= )
	rsh?		( net-misc/netkit-rsh )
	slurm?		( sys-cluster/slurm )"

DEPEND="
	${RDEPEND}
	mrsh? ( sys-auth/mrsh )"
BDEPEND="
	test? ( dev-util/dejagnu )"

PATCHES=( "${FILESDIR}/pdsh-header-compatibility-with-slurm.patch" )

src_configure() {
	local myconf=(
		--disable-static
		--enable-shared
		--with-machines
		$(use_with crypt ssh)
		$(use_with exec)
		$(use_with genders)
		$(use_with mrsh)
		$(use_with netgroup)
		$(use_with nodeupdown)
		$(use_with readline)
		$(use_with rsh)
		$(use_with ssh)
		$(use_with xcpu)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
