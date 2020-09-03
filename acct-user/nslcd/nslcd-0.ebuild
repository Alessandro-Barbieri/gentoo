# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for nss-pam-ldapd"

ACCT_USER_ID=357
ACCT_USER_GROUPS=( nslcd )

acct-user_add_deps
