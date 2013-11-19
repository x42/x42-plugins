#!/bin/bash

GITMASTER=${GITBRANCH:-master}
GITDEBIAN=${GITBRANCH:-debian}

echo -n "update submodules to latest tagged rev? [N/y]"
read -n1 a
echo
if test "$a" == "y" -o "$a" == "Y"; then
	git checkout $GITMASTER
	make tagupdate
	git commit -a -m "update submodules"
fi

git checkout $GITDEBIAN || git checkout -b $GITDEBIAN origin/$GITDEBIAN || exit
git merge --no-edit $GITMASTER

VERSION=$(git submodule --quiet foreach git show -s --format="%ci" HEAD | cut -d' ' -f 1 | sed 's/-//g' | sort -nr | head -n 1)
REVISIONS=$(git submodule foreach git describe --tags | tr "\n" " " | sed 's/Entering /\* /g')

# interactively edit changelog
debchange --distribution unstable --newversion "${VERSION}-0.1" "versions: ${REVISIONS}"
debchange --edit
git commit debian/changelog -m "finalize changelog"

DEBRELEASE=$(head -n1 debian/changelog | cut -d ' ' -f 2 | sed 's/[()]*//g')

BUILDDIR=/tmp/x42-${DEBRELEASE}
rm -rf ${BUILDDIR}

git-buildpackage \
	--git-no-pristine-tar \
	--git-upstream-branch=$GITMASTER --git-debian-branch=$GITDEBIAN \
	--git-upstream-tree=branch --git-ignore-branch \
	--git-export-dir=${BUILDDIR} --git-cleaner=/bin/true \
	--git-force-create \
	-rfakeroot $@

ERROR=$?

git checkout $GITMASTER

if test $ERROR != 0; then
	exit $ERROR
fi

lintian -i --pedantic ${BUILDDIR}/x42-lv2-plugins_${DEBRELEASE}_*.changes \
	| tee /tmp/x42.issues

echo
echo
ls -l ${BUILDDIR}/x42-lv2-plugins_${DEBRELEASE}_*.changes
ls -l ${BUILDDIR}/x42-lv2-plugins_${DEBRELEASE}_*.deb

CHANGES=$(ls ${BUILDDIR}/x42-lv2-plugins_${DEBRELEASE}_*.changes)
echo
echo "dput ${CHANGES}"
