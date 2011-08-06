################################################################################
# Backout multiple non-consecutive changesets.
# Pass all wanted changesets as arguments.
# After this, just have to hg qfinish qbase:qtip && hg push

backout_n2o() {
  if [ $# -lt 1 ]
  then
    exit 1
  fi

  local MESSAGE="Backout changesets"

  hg update -C || exit 1
  hg qpop -a || exit 1
  hg pull || exit 1

  for CHANGESET in $*
  do
    hg update $CHANGESET || exit 1
    hg revert -a -r $(hg parents -r $CHANGESET --template '{node|short}') || exit 1
    hg qdelete $CHANGESET.diff
    hg qnew -f $CHANGESET.diff
    hg qpop || exit 1
    MESSAGE="$MESSAGE $CHANGESET,"
  done

  hg update -r default || exit 1

  hg qdelete backout.diff > /dev/null 2>&1
  hg qnew backout.diff -m "$MESSAGE"

  for CHANGESET in $*
  do
    hg qfold $CHANGESET.diff
  done

  hg qrefresh -e
  hg outgoing -v
}﻿