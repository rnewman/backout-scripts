################################################################################
# Backout multiple consecutive changesets.
# - first argument is the most recent changeset
# - second argument is the least recent changeset
# After this, just have to hg qfin -a && hg push

backout_range_n2o() {
  if [ $# -lt 2 ]
  then
    exit 1
  fi

  local MESSAGE="Backout changesets"

  hg update -C || exit 1
  hg qpop -a || exit 1
  hg pull || exit 1

  hg update $1 || exit 1
  hg revert -a -r $(hg parents -r $2 --template '{node|short}') || exit 1

  MESSAGE="$MESSAGE $(hg log -r $2:$1 --template '{node|short}, ')"

  hg qdelete backout.diff > /dev/null 2>&1
  hg qnew backout.diff -f -m "$MESSAGE"
  hg qrefresh -e
  hg qpop
  hg update -r default
  hg qpush
  hg outgoing -v
}