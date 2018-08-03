# A wrapper around pip package to pull in undeclared dependencies.

load("@requirements//:requirements.bzl", "requirement")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD

py_library(
    name = "github",
    srcs = ["github.py"],
    deps = [
        requirement("PyGithub"),
<<<<<<< HEAD
        requirement("jwt"),  # Implicit dependency.
        requirement("cryptography"),  # Implicit dependency.
=======
>>>>>>> c1995bae2... More //third_party/py packages.
    ],
)
