"Sqids Bazel Unittests"

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//:sqids.bzl", "sqids")

def _encode_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    asserts.equals(env, s.encode([1, 2, 3]), "86Rf07")

    return unittest.end(env)

encode_test = unittest.make(_encode_test_impl)

def sqids_test_suite(name = "sqids_tests"):
    unittest.suite(
        name,
        encode_test,
    )
