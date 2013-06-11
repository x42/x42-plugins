#!/bin/sh

DEBRELEASE=$(head -n1 debian/changelog | cut -d ' ' -f 2 | sed 's/[()]*//g')

TMPDIR=/tmp/x42-${DEBRELEASE}
rm -rf ${TMPDIR}

GITMASTER=${GITBRANCH:-master}
GITDEBIAN=${GITBRANCH:-debian}

git checkout $GITDEBIAN || git checkout -b $GITDEBIAN origin/$GITDEBIAN || exit

git-buildpackage \
	--git-no-pristine-tar \
	--git-upstream-branch=$GITMASTER --git-debian-branch=$GITDEBIAN \
	--git-upstream-tree=branch --git-ignore-branch \
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
