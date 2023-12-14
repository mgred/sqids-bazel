# Sqids for Bazel

Unoffical port of [sqids](https://sqids.org/) written in Starlark for the Bazel build tool.

> [!NOTE]
> This library currently only works with Bzlmod.

`MODULE.bazel`:

```starlark
bazel_dep(name = "sqids_bazel")

git_override(
    name = "sqids_bazel",
    remote = "https://github.com/mgred/sqids-bazel",
    commit = "<commit_hash>",
)
```

Use in file:

```starlark
load("@sqids_bazel//:defs.bzl", "sqids")

genrule(
    name = "file",
    outs = ["hash"],
    cmd = "echo '%s' > $(OUTS)" % sqids().encode([1, 2, 3]),
)
```
