# Typescript node

# following this: https://khalilstemmler.com/blogs/typescript/node-starter-project/

npm init -y
npm install -D typescript
npm install -D @types/node

npx tsc --init --rootDir src --outDir dest --target es2017 \
	--esModuleInterop --resolveJsonModule --lib es2017 \
	--module commonjs --allowJs true --noImplicitAny true

npm --save-dev ts-node
npm --save-dev prettier
npm --save-dev eslint

npm install --save-dev eslint @js-soft/eslint-config-ts

zshxi <<<"code ."