require 'minitest/autorun'

class Utf8Challenges < Minitest::Test
  # Your challenge: unskip each test and make it pass!

  # Your constraint: find the answers by looking things up yourself, not by
  # writing Ruby code to calculate them.

  # Your caveat: as usual, much of the below is oversimplified for the sake of
  # clarity.

  describe 'ASCII' do
    # ASCII is an international standard for representing characters as numbers
    # (“code points”).

    # Before the 1960s, different computer manufacturers invented their own
    # schemes for mapping characters to code points, so a text file created on
    # one computer wouldn’t necessarily be readable on another computer. ASCII
    # solved this compatibility problem by providing a single mapping for
    # everyone to use.

    # ASCII specifies that the character “A” is code point 65, “B” is code
    # point 66, and so on. ASCII code points are 7 bits wide (0–127 in decimal,
    # 0x00–0x7F in hexadecimal, 0b0000000–0b1111111 in binary) because that
    # provides enough unique code points to represent all the alphanumeric
    # characters (in the English alphabet) and punctuation (in the United
    # States), with a few left over for non-printable “control codes” (e.g.
    # line feed, carriage return, tab, backspace, beep) that were used by old
    # computer terminals.

    # Since it’s a 7-bit number, every ASCII code point fits in a single byte,
    # with one unused bit left over. We usually write code points in
    # hexadecimal — “A” is 0x41, “B” is 0x42, etc — where each digit represents
    # half a byte.

    # https://en.wikipedia.org/wiki/ASCII#Character_set
    ASCII = Encoding::US_ASCII

    specify 'bytes to ASCII string' do
      skip

      bytes = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
      expected_string = '' # TODO

      assert bytes_to_string(bytes, as: ASCII) == expected_string.encode(ASCII)
    end

    specify 'ASCII string to bytes' do
      skip

      string = 'world'
      expected_bytes = [] # TODO

      assert string.encode(ASCII).bytes == expected_bytes
    end
  end

  describe 'ISO-8859-1' do
    # But — spoilers! — English isn’t the only language, and the United States
    # isn’t the only country.

    # Some European countries, for example, use alphanumeric characters (like
    # “é” and “ß”) and punctuation (like “£” and “¡”) which don’t appear in
    # ASCII. The ISO-8859-1 standard extends ASCII with an additional 128 code
    # points which are mapped to some of these extra characters.

    # ISO-8859-1 code points are 8 bits wide, so they all still fit in a single
    # byte. Note that ISO-8859-1 is backwards-compatible with ASCII: every
    # valid ASCII string is also a valid ISO-8859-1 string containing the same
    # characters.

    # https://en.wikipedia.org/wiki/ISO/IEC_8859-1#Code_page_layout
    ISO_8859_1 = Encoding::ISO_8859_1

    specify 'bytes to ISO-8859-1 string' do
      skip

      bytes = [0x63, 0x61, 0x66, 0xE9]
      expected_string = '' # TODO

      assert bytes_to_string(bytes, as: ISO_8859_1) == expected_string.encode(ISO_8859_1)
    end

    specify 'ISO-8859-1 string to bytes' do
      skip

      string = '£50'
      expected_bytes = [] # TODO

      assert string.encode(ISO_8859_1).bytes == expected_bytes
    end
  end

  describe 'Unicode' do
    # But — spoilers again! — more languages and countries exist. The 256 code
    # points of ISO-8859-1 are nowhere near enough to represent all
    # alphanumeric characters (e.g. “ø”, “ž”, “τ”, “お”) or punctuation (e.g.
    # “€”, “™”, “၍”) used everywhere in the world.

    # The Unicode standard attempts to assign a code point to every possible
    # character, whatever that means. As you might imagine, Unicode is huge:
    # the current version (14.0.0, September 2021) defines 144,697 code points.
    # To provide some organisational structure, those code points are divided
    # into 17 large sections called “planes”, and each plane is subdivided into
    # smaller “blocks”.

    # For example, the first plane is the Basic Multilingual Plane, and the
    # first block in that plane is the Basic Latin block, which contains all of
    # the ASCII characters. (For backwards compatibility, the Basic Latin code
    # points are identical to ASCII.)

    # Unicode also introduces a standard notation for code points. They’re
    # written as “U+” followed by at least four hexadecimal digits, padded with
    # leading zeros if necessary. So the Unicode code point for “A”, 0x41, is
    # usually written U+0041. The “U+” part makes it clear that it’s a Unicode
    # code point rather than a generic hexadecimal number.

    # Clearly not all 144,697 code points can fit in a single byte; the largest
    # ones require 21 bits (almost 3 bytes). Unicode itself doesn’t specify how
    # to represent code points as bytes, so we’ll just think about code points
    # for now and return to bytes shortly.

    # https://en.wikipedia.org/wiki/Plane_(Unicode)#Assigned_characters
    # https://en.wikipedia.org/wiki/Plane_(Unicode)#BMP
    # https://en.wikipedia.org/wiki/Unicode_block#List_of_blocks
    # https://en.wikipedia.org/wiki/Basic_Latin_(Unicode_block)

    specify 'Unicode string to code points' do
      skip

      # tip: https://www.fileformat.info/info/unicode/char/search.htm
      codepoints = [0x3C0, 0x20, 0x2248, 0x20, 0x33]
      expected_string = '' # TODO

      assert codepoints_to_string(codepoints) == expected_string
    end

    specify 'code points to Unicode string' do
      skip

      string = '⌘C ⌘V'
      expected_codepoints = [] # TODO

      assert string.codepoints == expected_codepoints
    end
  end

  describe 'UTF-32' do
    # Unicode is useful but it only solves half of the problem.

    # Computer memory uses bytes, so a computer must ultimately store a string
    # as a sequence of bytes, not code points. Even if we know all of the
    # Unicode code points for a string, we still need a way to represent those
    # code points as bytes so we can store the string in a computer.

    # It’s not obvious how to do this because some code points are small enough
    # to fit inside 1 byte, but others are large enough to require 2 or 3
    # bytes. Ideally we should store them in a way that makes the string easy
    # to manipulate: starting with the bytes themselves, we must be able to
    # decode them back into code points, compute the length of the string (in
    # characters), retrieve a character or substring at a specific character
    # index, and so on.

    # Perhaps the simplest approach is to use 4 bytes (32 bits) per code point.
    # This “fixed-length encoding” has the advantage of being easy to
    # understand and manipulate: to find the length of the string, divide the
    # number of bytes by 4; to find the byte offset of a given character,
    # multiply the character index by 4, etc. Note that we only really need 3
    # bytes (24 bits) to represent even the largest 21-bit Unicode code point,
    # but multiples of 4 are more convenient for computers to handle.

    # This way of encoding code points as bytes is called UTF-32, which stands
    # for “32-bit Unicode Transformation Format”.

    # Example 1: “A”
    #
    # The Unicode code point for “A” is U+0041 (0b1000001), the same as in
    # ASCII. To represent this in UTF-32 we begin with a template of four
    # blank bytes:
    #
    #   ________ ________ ________ ________
    #
    # Next we fill in the blanks with the 7 bits of the code point, starting
    # from the right-hand end:
    #
    #   ________ ________ ________ _1000001
    #
    # Finally we fill the remaining blanks with zeros:
    #
    #   00000000 00000000 00000000 01000001
    #
    # The first three bytes were completely unused by the code point and so
    # contain all zeros.
    #
    # So the UTF-32 encoding of U+0041 is [0b00000000, 0b00000000, 0b00000000,
    # 0b01000001], or [0x00, 0x00, 0x00, 0x41] in hexadecimal:
    #
    #   >> puts [0x00, 0x00, 0x00, 0x41].pack('C*').force_encoding(Encoding::UTF_32BE)
    #   A

    # Example 2: “😭”
    #
    # The Unicode code point for “😭” is U+1F62D (0b11111011000101101). We
    # start with four blank bytes again…
    #
    #   ________ ________ ________ ________
    #
    # …then fill in the 17 bits of the code point…
    #
    #   ________ _______1 11110110 00101101
    #
    # …and finally fill the remaining blanks with zeros:
    #
    #   00000000 00000001 11110110 00101101
    #
    # In this case, the code point is larger and its bits have spilled over
    # into the second and third bytes, but the first byte is still all zeros.
    #
    # So the UTF-32 encoding of U+1F62D is [0b00000000, 0b00000001, 0b11110110,
    # 0b00101101], or [0x00, 0x01, 0xF6, 0x2D] in hexadecimal:
    #
    #   >> puts [0x00, 0x01, 0xF6, 0x2D].pack('C*').force_encoding(Encoding::UTF_32BE)
    #   😭

    # https://en.wikipedia.org/wiki/UTF-32
    UTF_32 = Encoding::UTF_32BE # “BE” is “big-endian”, i.e. most significant byte first

    specify 'bytes to UTF-32 string' do
      skip

      bytes =
        [
          0x00, 0x00, 0x03, 0xC0,
          0x00, 0x00, 0x00, 0x20,
          0x00, 0x00, 0x22, 0x48,
          0x00, 0x00, 0x00, 0x20,
          0x00, 0x00, 0x00, 0x33
        ]
      expected_string = '' # TODO

      assert bytes_to_string(bytes, as: UTF_32) == expected_string.encode(UTF_32)
    end

    specify 'UTF-32 string to bytes' do
      skip

      string = '⌘C ⌘V'
      expected_bytes = [] # TODO

      assert string.encode(UTF_32).bytes == expected_bytes
    end
  end

  describe 'UTF-8' do
    # The big downside of UTF-32 is that it wastes a lot of space: most of the
    # bytes in a UTF-32 string are empty. It’d be better if we had a way to
    # represent smaller code points with fewer bytes while still being able to
    # use more bytes to represent larger ones when needed, so that space is
    # used more efficiently without sacrificing the ability to represent any
    # Unicode character.

    # The big problem with saving space in this way is that a “variable-length
    # encoding” has the potential to make string manipulation much more
    # complicated, because the number of bytes per character will vary over the
    # course of the string. This makes it harder to determine string length and
    # convert between character indexes and byte offsets. It also makes it
    # unclear where in memory each character starts and ends: in a sequence of
    # bytes representing a UTF-32 string we always know that every fourth byte
    # is the start of a new character, but if each character takes up a
    # different number of bytes it’s less obvious where the boundaries are.

    # A clever solution is an encoding called UTF-8, “8-bit Unicode
    # Transformation Format”. Instead of using a fixed four-byte template like
    # UTF-32, it dynamically chooses a one-, two-, three- or four-byte template
    # for each code point depending on how many bits that code point needs:

    #   0–7 bits: 0_______
    #  8–11 bits: 110_____ 10______
    # 12–16 bits: 1110____ 10______ 10______
    # 17–21 bits: 11110___ 10______ 10______ 10______

    # This means that every 7-bit Unicode code point is represented as a single
    # byte with a leading zero bit, i.e. identically to ASCII. Larger code
    # points are split across multiple bytes, with a special bit pattern at the
    # beginning of each byte to indicate whether it’s a “lead byte” (0b110…,
    # 0b1110… or 0b11110…, for two-, three- and four-byte sequences
    # respectively) or a “continuation byte” (0b10…).

    # Example: “€”
    #
    # The Unicode code point for “€” is U+20AC, or 0b10000010101100 in binary,
    # which is 14 bits long. So we start with the three-byte template (for code
    # points 12–16 bits long)…
    #
    #   1110____ 10______ 10______
    #
    # …and fill in the blanks with the 14 bits from the code point, starting at
    # the right-hand end…
    #
    #   1110__10 10000010 10101100
    #
    # …then fill the remaining blanks with zeros:
    #
    #   11100010 10000010 10101100
    #
    # So the UTF-8 encoding of U+20AC is [0b11100010, 0b10000010, 0b10101100],
    # or [0xE2, 0x82, 0xAC] in hexadecimal:
    #
    #   >> puts [0xE2, 0x82, 0xAC].pack('C*').force_encoding(Encoding::UTF_8)
    #   €

    # This design has many advantages:
    #
    # * it’s backwards-compatible with ASCII, which means every valid ASCII
    #   string is also a valid UTF-8 string containing the same characters;
    #
    # * a byte representing an ASCII character, e.g. a space (0x20), can never
    #   appear as part of a multi-byte sequence, so it’s safe to split a UTF-8
    #   string on spaces just by looking for the byte 0x20 without decoding the
    #   other characters;
    #
    # * it’s “self-synchronising”, which means we can easily spot the start
    #   of each character in memory by looking for the lead byte pattern;
    #
    # * in the best case (i.e. ASCII) it only uses one byte per character;
    #
    # * in the worst case it doesn’t use any more bytes than UTF-32;
    #
    # * encoding and decoding uses simple bitwise operations which can be
    #   implemented efficiently; and
    #
    # * it’s pretty easy to automatically guess whether a given sequence of
    #   bytes represents a UTF-8 string, because certain individual bytes (e.g.
    #   any byte starting 0b11111…) and combinations of bytes (e.g. any pair of
    #   bytes starting 0b110… 0b0…) are not valid UTF-8.

    # https://en.wikipedia.org/wiki/UTF-8
    UTF_8 = Encoding::UTF_8

    specify 'bytes to UTF-8 string' do
      skip

      bytes = [0x49, 0x20, 0xE2, 0x9D, 0xA4, 0x20, 0xF0, 0x9F, 0x8D, 0x95]
      expected_string = '' # TODO

      assert bytes_to_string(bytes, as: UTF_8) == expected_string.encode(UTF_8)
    end

    specify 'UTF-8 string to bytes' do
      skip

      string = 'Voilà! 🎉'
      expected_bytes = [] # TODO

      assert string.encode(UTF_8).bytes == expected_bytes
    end
  end
end

# https://docs.ruby-lang.org/en/3.1/Array.html#method-i-pack
BYTES_PACK_TEMPLATE = 'C*' # zero or more unsigned 8-bit integers
CODEPOINTS_PACK_TEMPLATE = 'U*' # zero or more Unicode code points

def bytes_to_string(bytes, as:)
  bytes.pack(BYTES_PACK_TEMPLATE).force_encoding(as)
end

def codepoints_to_string(codepoints)
  codepoints.pack(CODEPOINTS_PACK_TEMPLATE)
end
