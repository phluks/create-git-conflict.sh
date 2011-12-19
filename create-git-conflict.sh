#!/bin/sh

if [ "$1" != "--run" ]; then
	echo
	echo You must give the run param:
	echo "  create-git-conflict.sh --run"
	echo
	echo WARNING: The script deletes branches a and b before it re-creates
	echo them. Make sure, that you don\'t have any branches named a or b in
	echo your git repo. The script cannot check for it
	echo
	exit 1
fi

git show > /dev/null
if [ "$?" != 0 ]; then
	echo
	echo It seems that you are not in a git repo!
  echo
  echo If you are, you may need to make an initial commit.
	echo
	exit 1
fi

git checkout master

# delete branches
# just ingore the noise it only barfs the first time.
git branch -D a
git branch -D b

# Lets get dirty
echo Making some files.
cat > hi  <<'HERE'
Where does
this
go to?
HERE

cat > there <<'HERE'
Here is there!

When you are

there.
HERE

echo Committing some files.
git add .
git commit -m "Pre conflict"

# Lets start the show
git checkout -b b

echo Checking out branch 'a' and making some noise.
git checkout -b a

# Lets get dirty
echo Making some files.
cat > hi  <<'HERE'
Where does
it
go to?
HERE

cat > there <<'HERE'
Here is there!
When you are
all the way
there.
HERE

echo Committing some files.
git add .
git commit -m "Making noise on a"

echo Checking out branch 'b' and making some noise.
git checkout b

# Lets get dirty
echo Making some files.
cat > hi  <<'HERE'
Where does
this want to
go to?
HERE

cat > there <<'HERE'
Here is there!

When you are
not here, but
there.
HERE

echo Committing some files.
git add .
git commit -m "Making noise on b"

echo time to merge b into a
git checkout a
git merge b
echo
echo The show is on...
