# A wrapper around pip package to pull in undeclared dependencies.

load("@requirements//:requirements.bzl", "requirement")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD

py_library(
    name = "github",
<<<<<<< HEAD
    srcs = ["//third_party/py:empty.py"],
    deps = [
        requirement("PyGithub"),
        requirement("jwt"),  # Implicit dependency.
        requirement("cryptography"),  # Implicit dependency.
=======
    srcs = ["github.py"],
    deps = [
        requirement("PyGithub"),
>>>>>>> c1995bae2... More //third_party/py packages.
    ],
)
