# Basic golang Template

zsh-xi st <<EOF &
nvim -p ./main.go
EOF

zsh-xi st <<EOF &
echo main.go | entr -rc go run /_
EOF
