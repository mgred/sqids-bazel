"Encoding Tests"

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//:defs.bzl", "sqids")

def _simple_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    numbers = [1, 2, 3]
    id = "86Rf07"
    asserts.equals(env, s.encode(numbers), id)
    asserts.equals(env, s.decode(id), numbers)

    return unittest.end(env)

simple_test = unittest.make(_simple_test_impl)

def _different_inputs_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    numbers = [0, 0, 0, 1, 2, 3, 100, 1000, 100000, 1000000]
    asserts.equals(env, s.decode(s.encode(numbers)), numbers)

    return unittest.end(env)

different_inputs_test = unittest.make(_different_inputs_test_impl)

def _incremental_numbers_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    ids = {
        "bM": [0],
        "Uk": [1],
        "gb": [2],
        "Ef": [3],
        "Vq": [4],
        "uw": [5],
        "OI": [6],
        "AX": [7],
        "p6": [8],
        "nJ": [9],
    }
    for id_str, numbers in ids.items():
        asserts.equals(env, s.encode(numbers), id_str)
        asserts.equals(env, s.decode(id_str), numbers)

    return unittest.end(env)

incremental_numbers_test = unittest.make(_incremental_numbers_test_impl)

def _incremental_numbers_same_index_0_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    ids = {
        "SvIz": [0, 0],
        "n3qa": [0, 1],
        "tryF": [0, 2],
        "eg6q": [0, 3],
        "rSCF": [0, 4],
        "sR8x": [0, 5],
        "uY2M": [0, 6],
        "74dI": [0, 7],
        "30WX": [0, 8],
        "moxr": [0, 9],
    }
    for id_str, numbers in ids.items():
        asserts.equals(env, s.encode(numbers), id_str)
        asserts.equals(env, s.decode(id_str), numbers)

    return unittest.end(env)

incremental_numbers_same_index_0_test = unittest.make(_incremental_numbers_same_index_0_test_impl)

def _incremental_numbers_same_index_1_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    ids = {
        "SvIz": [0, 0],
        "n3qa": [0, 1],
        "tryF": [0, 2],
        "eg6q": [0, 3],
        "rSCF": [0, 4],
        "sR8x": [0, 5],
        "uY2M": [0, 6],
        "74dI": [0, 7],
        "30WX": [0, 8],
        "moxr": [0, 9],
    }
    for id_str, numbers in ids.items():
        asserts.equals(env, s.encode(numbers), id_str)
        asserts.equals(env, s.decode(id_str), numbers)

    return unittest.end(env)

incremental_numbers_same_index_1_test = unittest.make(_incremental_numbers_same_index_1_test_impl)

def _multi_input_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    numbers = list(range(100))
    asserts.equals(env, numbers, s.decode(s.encode(numbers)))

    return unittest.end(env)

multi_input_test = unittest.make(_multi_input_test_impl)

def _encoding_no_numbers_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    asserts.equals(env, s.encode(), "")

    return unittest.end(env)

encoding_no_numbers_test = unittest.make(_encoding_no_numbers_test_impl)

def _decoding_empty_string_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    asserts.equals(env, s.decode(""), [])

    return unittest.end(env)

decoding_empty_string_test = unittest.make(_decoding_empty_string_test_impl)

def _decoding_invalid_character_test_impl(ctx):
    env = unittest.begin(ctx)

    s = sqids()
    asserts.equals(env, s.decode("*"), [])

    return unittest.end(env)

decoding_invalid_character_test = unittest.make(_decoding_invalid_character_test_impl)

def encoding_test_suite(name = "encoding_test_suite"):
    unittest.suite(
        name,
        decoding_empty_string_test,
        decoding_invalid_character_test,
        different_inputs_test,
        encoding_no_numbers_test,
        incremental_numbers_same_index_0_test,
        incremental_numbers_same_index_1_test,
        incremental_numbers_test,
        multi_input_test,
        simple_test,
    )
