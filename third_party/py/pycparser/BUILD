# A wrapper around pip package to pull in undeclared dependencies.

load("@requirements//:requirements.bzl", "requirement")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD

py_library(
    name = "pycparser",
<<<<<<< HEAD
    srcs = ["//third_party/py:empty.py"],
=======
    srcs = ["pycparser.py"],
>>>>>>> c1995bae2... More //third_party/py packages.
    deps = [
        requirement("pycparser"),
        requirement("pycparserext"),
    ],
)
