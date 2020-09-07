# Linux shared memory IPC (C)

zsh-xi $TERMINAL <<EOF &
nvim -p server.c client.c Makefile
EOF

zsh-xi $TERMINAL <<-EOF &
echo "server.c\nMakefile" |
  entr -rcs "make && ./server"
EOF

zsh-xi $TERMINAL <<EOF &
echo "client.c\nMakefile" |
  entr -rcs "sleep 0.1; make && ./client"
EOF
