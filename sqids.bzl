"Squids Bazel"

load("@aspect_bazel_lib//lib:strings.bzl", "ord")
load("//:constants.bzl", "DEFAULT_ALPHABET", "DEFAULT_BLOCKLIST", "DEFAULT_MIN_LENGTH")

_FOREVER = range(1073741824)

def _unique(arr):
    ret = list()
    for a in arr:
        if a not in ret:
            ret.append(a)
    return ret

def _sum(numbers):
    ret = 0
    for n in numbers:
        ret += n
    return ret

def _to_id(num, alphabet):
    id_chars = []
    chars = alphabet.elems()
    result = num

    for _ in _FOREVER:
        id_chars.insert(0, chars[result % len(chars)])
        result = result // len(chars)
        if result == 0:
            break

    return "".join(id_chars)

def _shuffle(alphabet):
    chars = list(alphabet.elems())

    j = len(chars) - 1
    for i in _FOREVER:
        if j > 0:
            r = (i * j + ord(chars[i]) + ord(chars[j])) % len(chars)
            chars[i], chars[r] = chars[r], chars[i]
            j -= 1
            continue
        break

    return "".join(chars)

def _is_blocked_id(id_, blocklist):
    id_ = id_.lower()

    for word in blocklist:
        if len(word) > len(id_):
            continue
        if len(id_) <= 3 or len(word) <= 3:
            if id_ == word:
                return True
        elif any([c.isdigit() for c in word.elems()]):
            if id_.startswith(word) or id_.endswith(word):
                return True
        elif word in id_:
            return True

    return False

def _encode_numbers(options, numbers, increment):
    if increment > len(options.alphabet):
        fail("Reached max attempts to re-generate the ID")

    offset = _sum(
        [
            ord(options.alphabet[v % len(options.alphabet)]) + i
            for i, v in enumerate(numbers)
        ],
    )
    offset = (offset + len(numbers)) % len(options.alphabet)
    offset = (offset + increment) % len(options.alphabet)
    alphabet = options.alphabet[offset:] + options.alphabet[:offset]
    prefix = alphabet[0]
    alphabet = alphabet[::-1]
    ret = [prefix]

    for i, num in enumerate(numbers):
        ret.append(_to_id(num, alphabet[1:]))

        if i >= len(numbers) - 1:
            continue

        ret.append(alphabet[0])
        alphabet = _shuffle(alphabet)

    id_ = "".join(ret)

    if options.min_length > len(id_):
        id_ += alphabet[0]

        for _ in _FOREVER:
            if (options.min_length - len(id_)) > 0:
                alphabet = _shuffle(alphabet)
                id_ += alphabet[:min(options._min_length - len(id_), len(alphabet))]
                continue
            break

    return id_

def _encode(options, numbers):
    id = ""
    if numbers == None:
        return id

    in_range_numbers = [n for n in numbers if n >= 0]
    if len(in_range_numbers) != len(numbers):
        fail("Encoding supports numbers greater than 0")

    for i in _FOREVER:
        id = _encode_numbers(options, numbers, i)
        if not _is_blocked_id(id, options.blocklist):
            break
    return id

def _check_options(alphabet, min_length):
    for char in alphabet.elems():
        if ord(char) > 127:
            fail("Alphabet cannot contain multibyte characters")

    if len(alphabet) < 3:
        fail("Alphabet length must be at least 3")

    if len(_unique(alphabet.elems())) != len(alphabet):
        fail("Alphabet must contain unique characters")

    if type(min_length) != "int":
        fail("Minimum length must be an integer")

    MIN_LENGTH_LIMIT = 255
    if min_length < 0 or min_length > MIN_LENGTH_LIMIT:
        fail("Minimum length has to be between 0 and %s" % MIN_LENGTH_LIMIT)

def sqids(blocklist, alphabet = DEFAULT_ALPHABET, min_length = DEFAULT_MIN_LENGTH):
    """Generate unique IDs from numbers

    Example:
      ```starlark
      load("@sqids_bazel//:defs.bzl", "sqids")

      s = sqids()
      print(s.encode([1, 2, 3]) // 86Rf07
      ```

    Args:
      alphabet: list of characters to generate the ids from
      blocklist: list of words to avoid in hashes
      min_length: minimal count of characters

    Returns:
      a `struct` holding the `encode` and `decode` methods.
    """

    _check_options(alphabet, min_length)

    options = struct(
        alphabet = _shuffle(alphabet),
        blocklist = blocklist or DEFAULT_BLOCKLIST,
        min_length = min_length,
    )

    def __encode(numbers):
        return _encode(options, numbers)

    return struct(
        encode = __encode,
    )