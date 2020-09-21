# Linux shared memory IPC (C)

zsh-xi $TERMINAL <<EOF &
nvim -p server.c client.c Makefile
EOF

# NOTE: cannot use 'entr -r' as terminal i/o won't be forwarded to the
#       child process.
zsh-xi $TERMINAL <<EOF &
  entr -cs 'make && ./server' <<-ENTR
		server.c
		Makefile
	ENTR
EOF

zsh-xi $TERMINAL <<EOF &
  entr -rcs 'sleep 1.1; make && ./client' <<-ENTR
		client.c
		Makefile
	ENTR
EOF
