# Linux shared memory IPC (C)

st zsh -c 'nvim -p ./server.c client.c Makefile; zsh -i' &
st zsh -c "echo  \"./server.c\nMakefile\" | entr -rcs \"make && ./server\"; zsh -i" &
st zsh -c "echo  \"./client.c\nMakefile\" | entr -rcs \"make && ./client\"; zsh -i" &
