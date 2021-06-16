# Basic latex journal article

# Open editor
zsh-xi st <<EOF &
nvim -p ./main.tex
EOF

# Open pdf preview. Generate a dummy file to open.
mkdir -p build
echo | groff -T pdf > build/main.pdf
zathura --fork build/main.pdf

# Open terminal where iterative compilation takes place
zsh-xi st <<EOF &
echo "build.zsh" | entr -rc /_ build
EOF
