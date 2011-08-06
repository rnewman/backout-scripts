qdiff() {
  local REV=qtip
  if [ $1 ]
  then
    REV=$1
  fi

  hg log -r "$REV" --template '# HG changeset patch\n# User {author}\n{desc}\n\n'
  hg qdiff
}﻿