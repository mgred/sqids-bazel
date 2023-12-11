"Alphabet Tests"

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//:defs.bzl", "decode", "encode", "sqids")

def _simple_test_impl(ctx):
    env = unittest.begin(ctx)

    alphabet = "0123456789abcdef"
    s = sqids(alphabet = alphabet)

    numbers = [1, 2, 3]
    id = "489158"

    asserts.equals(env, s.encode(numbers), id)
    asserts.equals(env, encode(numbers, alphabet), id)
    asserts.equals(env, s.decode(id), numbers)
    asserts.equals(env, decode(id, alphabet), numbers)

    return unittest.end(env)

simple_test = unittest.make(_simple_test_impl)

def _short_alphabet_test_impl(ctx):
    env = unittest.begin(ctx)

    alphabet = "abc"
    s = sqids(alphabet = alphabet)

    numbers = [1, 2, 3]

    asserts.equals(env, s.decode(s.encode(numbers)), numbers)
    asserts.equals(env, decode(encode(numbers, alphabet), alphabet), numbers)

    return unittest.end(env)

short_alphabet_test = unittest.make(_short_alphabet_test_impl)

def _long_alphabet_test_impl(ctx):
    env = unittest.begin(ctx)

    alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+|{}[];:'\"/?.>,<`~"
    s = sqids(alphabet = alphabet)

    numbers = [1, 2, 3]

    asserts.equals(env, s.decode(s.encode(numbers)), numbers)
    asserts.equals(env, decode(encode(numbers, alphabet), alphabet), numbers)

    return unittest.end(env)

long_alphabet_test = unittest.make(_long_alphabet_test_impl)

def alphabet_test_suite(name = "alphabet_test_suite"):
    unittest.suite(
        name,
        long_alphabet_test,
        short_alphabet_test,
        simple_test,
    )
