---
title: Markdown to Beamer
author: Stan
theme: metropolis
colortheme: beaver
---

# Pandoc Markdown

## Formatting

### Text Formatting
Text may be formatted *italic*, **bold**, ***bold+italic***.

### Lists
+ Item A
+ Item B
  + Item B.1
  + Item B.2
+ Item C

### Links
<!--TODO(fix): Links are not highlighted-->
[Inline](example.com) or [reference][1] links.

[1]: example.com

## Images

![Image Showcase](assets/doggy.jpg){height=250px}

## Code Snippets

### Basic code snippet
```python
print('Hello World')
```

### Line numbering
```{.c .numberLines startFrom=7}
#include <stdio.h>

int main(int argc, char** argv) {
  printf('Hello World!\n');
  return 1
}
```

```{.c emphasize=2-2}
int maino() a
asdasdsaddas
asdasdsaddas
```

## Codebraid

**Codebraid required**. See [Codebraid github](https://github.com/gpoore/codebraid).

```{.python .cb.run name=part1 session=copy_source}
import random
random.seed(2)
rnums = [random.randrange(100) for n in range(10)]
```

```{.python .cb.run name=part2 session=copy_source}
print("Random numbers: {}".format(rnums))
```
```{.python .cb.paste copy=part1+part2 show=code+stdout}
```
