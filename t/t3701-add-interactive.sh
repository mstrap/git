if test_have_prereq !PERL
test_expect_success 'warn about add.interactive.useBuiltin' '
	cat >expect <<-\EOF &&
	warning: the add.interactive.useBuiltin setting has been removed!
	See its entry in '\''git help config'\'' for details.
	No changes.
	EOF

	for v in = =true =false
	do
		git -c "add.interactive.useBuiltin$v" add -p >out 2>actual &&
		test_must_be_empty out &&
		test_cmp expect actual || return 1
	done
'

	git diff --cached file >out &&
	grep "new mode" out &&
	grep "+content" out &&
	git diff file >out &&
	test_must_be_empty out
test_expect_success 'split hunk "add -p (no, yes, edit)"' '
test_expect_success 'edit, adding lines to the first hunk' '
test_expect_success 'reset -p with unmerged files' '
	test_when_finished "git checkout --force main" &&
	test_commit one conflict &&
	git checkout -B side HEAD^ &&
	test_commit two conflict &&
	test_must_fail git merge one &&

	# this is a noop with only an unmerged entry
	git reset -p &&

	# add files that sort before and after unmerged entry
	echo a >a &&
	echo z >z &&
	git add a z &&

	# confirm that we can reset those files
	printf "%s\n" y y | git reset -p &&
	git diff-index --cached --diff-filter=u HEAD >staged &&
	test_must_be_empty staged
'
