test-image: image
	printf 'speed 1000\nset pc=0xF000\nrun\nquit\n' | naken_util -bin -exe -address 61440 image > $@
	grep 'Illegal instruction at address 0xf08a' $@
