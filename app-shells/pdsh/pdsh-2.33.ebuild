# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A high-performance, parallel remote shell utility"
HOMEPAGE="https://computing.llnl.gov/linux/pdsh.html"
SRC_URI="https://github.com/chaos/pdsh/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt readline rsh slurm test"

RDEPEND="
	crypt? ( net-misc/openssh )
	readline? ( sys-libs/readline:0= )
	rsh? ( net-misc/netkit-rsh )
	slurm? ( sys-cluster/slurm )"

DEPEND="
	${RDEPEND}
	test? ( dev-util/dejagnu )"

PATCHES=( "${FILESDIR}/pdsh-header-compatibility-with-slurm.patch" )

PDSH_MODULES=(
		dshgroups exec genders netgroup nodeupdown mrsh ssh xcpu
)

IUSE_PDSH_MODULES="${PDSH_MODULES[@]}"

src_configure() {
	MODULE_CONFIG=""
	local m
	for m in ${IUSE_PDSH_MODULES[@]}; do
		MODULE_CONFIG="${MODULE_CONFIG} --with-${m}"
	done

	econf ${MODULE_CONFIG} \
		--disable-static \
		--enable-shared \
		--with-machines \
		$(use_with crypt ssh) \
		$(use_with readline) \
		$(use_with rsh) \
		$(use_with slurm)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
