#!/bin/sh

DEBRELEASE=$(head -n1 debian/changelog | cut -d ' ' -f 2 | sed 's/[()]*//g')

TMPDIR=/tmp/x42-${DEBRELEASE}
rm -rf ${TMPDIR}

GITBRANCH=${GITBRANCH:-master}

git-buildpackage \
	--git-no-pristine-tar \
	--git-upstream-branch=$GITBRANCH --git-debian-branch=$GITBRANCH \
	--git-upstream-tree=branch \
	--git-export-dir=${TMPDIR} --git-cleaner=/bin/true \
	--git-force-create \
	-rfakeroot $@

ERROR=$?

if test $ERROR != 0; then
	exit $ERROR
fi

lintian -i --pedantic ${TMPDIR}/x42-lv2-plugins_${DEBRELEASE}_*.changes \
	| tee /tmp/x42.issues

echo
echo
ls -l ${TMPDIR}/x42-lv2-plugins_${DEBRELEASE}_*.changes
ls -l ${TMPDIR}/x42-lv2-plugins_${DEBRELEASE}_*.deb
echo
echo "sudo dpkg -i ${TMPDIR}/x42-lv2-plugins_${DEBRELEASE}_*.deb"
