#!/bin/sh

test_description='git update-index --index-version test.
'

. ./test-lib.sh

test_expect_success 'setup' '
	echo content >file &&
	git add file &&
	git commit -m "initial import"
'

test_expect_success 'v2->v2 does not change index' '
	git update-index --index-version 2 &&
	test "$(test-tool index-version < .git/index)" = 2
'

test_expect_success 'v2->v3 does not change index' '
	git update-index --index-version 2 &&
	test "$(test-tool index-version < .git/index)" = 2
'

test_expect_success 'v2->v4 changes index' '
	git update-index --index-version 4 &&
	test "$(test-tool index-version < .git/index)" = 4
'

test_expect_success 'v4->v2 changes index' '
	git update-index --index-version 2 &&
	test "$(test-tool index-version < .git/index)" = 2
'

test_expect_success 'v3->v2 does not change index' '
	echo content2 >file2 &&
	git add -N file2 &&
	test "$(test-tool index-version < .git/index)" = 3 &&
	git update-index --index-version 2 &&
	test "$(test-tool index-version < .git/index)" = 3
'

test_expect_success 'v3->v2 changes index' '
	git rm --force file2 &&
	git update-index --index-version 2 &&
	test "$(test-tool index-version < .git/index)" = 2
'

test_expect_success 'v2->v4 does not change index if --unresolve gives error' '
	echo $PWD &&
	git branch m &&
	git checkout -b b &&
	echo content1 >file &&
	git add file &&
	git commit -m "branch change" &&

	git checkout m &&
	echo content2 >file &&
	git add file &&
	git commit -m "master change" &&

	test_must_fail git merge b &&
	test_must_fail git update-index --index-version 4 --unresolve foo &&
	test "$(test-tool index-version < .git/index)" = 2
'

test_done
