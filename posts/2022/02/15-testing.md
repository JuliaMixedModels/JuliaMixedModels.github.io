+++
title = "Testing, testing..."
mintoclevel = 2

descr = """
    Testing Franklin and deployment
    """
tags = ["Frankling", "blog"]
+++

# {{title}}

\toc

How hard is it to create small one-off examples and deploy them immediately?

## Basic formatting

See also [here](https://franklinjl.org/syntax/markdown/)

@@ctable
A   | header
:---|:---
yes | true
no  | false
@@

This has a footnote[^1]

[^1]: footnote definition

## Code block

### Not executed

```julia
x = 3
```

### Executed

```!
using DataFrames
DataFrame(; a=[1,2], b=["one", "two"])
```

```julia:snippet1
using LinearAlgebra, Random
Random.seed!(555)
a = randn(5)
round(norm(a), sigdigits=4)
```

\show{snippet1}