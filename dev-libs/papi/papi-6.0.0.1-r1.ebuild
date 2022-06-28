# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Performance Application Programming Interface"
HOMEPAGE="http://icl.cs.utk.edu/papi/"
SRC_URI="http://icl.cs.utk.edu/projects/${PN}/downloads/${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="lm-sensors mutex rocm" # TODO: cuda nvml

DEPEND="
	dev-libs/libatomic_ops
	dev-libs/libpfm
	virtual/mpi

	lm-sensors? ( sys-apps/lm-sensors )
	rocm? (
		dev-util/rocm-smi
		dev-util/rocprofiler
		dev-libs/rocr-runtime
	)
"
RDEPEND="${DEPEND}"

#PATCHES=( "${FILESDIR}/${P}-shared-libpfm.patch" )

src_prepare() {
	rm -r atomic_ops{,.h} libpfm* perfctr* || die
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	tc-export AR
	local components='stealtime sde rapl perf_event_uncore perf_event lustre io appio net infiniband'
	if use lm-sensors; then
		components="${components} lmsensors"
		export PAPI_LMSENSORS_ROOT="${EPREFIX}/usr"
	fi
	if use ppc; then
		components="${components} sensors_ppc powercap_ppc"
	else
		components="${components} powercap"
	fi
	if use rocm; then
		components="${components} rocm rocm_smi"
		export PAPI_ROCM_ROOT="${EPREFIX}/usr"
		export PAPI_ROCMSMI_ROOT="${EPREFIX}/usr"
		export ROCP_METRICS=""
		export HSA_TOOLS_LIB
#		export ROCP_TOOL_LIB
	fi

	local myeconfargs=(
		--with-components="${components} ${PAPI_COMPONENTS}"
		--with-perf-events
		--with-pfm-libdir="${EPREFIX}/usr/$(get_libdir)"
		--with-pfm-prefix="${EPREFIX}/usr"
		--with-shared-lib=yes
		--with-shlib-tools=yes
		--with-static-lib=no
		--without-static-tools

		$(use_with mutex pthread-mutexes)
	)

	CONFIG_SHELL="${EPREFIX}/bin/bash" econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc ../RE* ../ChangeLog*
	docinto html
	dodoc ../*.html

	insinto /usr/share/octave/site/m/papi
	doins -r Matlab/.

	find "${ED}" -name '*.a' -delete || die
	find "${ED}" -name '*.la' -delete || die
}
