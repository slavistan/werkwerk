# Basic C Template

st zsh -c 'nvim -p ./main.c Makefile; zsh -i' &
st zsh -c "echo  \"./main.c\nMakefile\" | entr -rcs \"make && ./main\"; zsh -i" &
