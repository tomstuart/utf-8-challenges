require 'minitest/autorun'

class Utf8Challenges < Minitest::Test
  describe 'ASCII' do
    # https://en.wikipedia.org/wiki/ASCII#Character_set
    ASCII = Encoding::US_ASCII

    specify 'bytes to ASCII string' do
      skip

      bytes = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
      expected_string = ''.encode(ASCII) # TODO

      assert string_from_bytes(bytes, encoding: ASCII) == expected_string
    end

    specify 'ASCII string to bytes' do
      skip

      string = 'world'.encode(ASCII)
      expected_bytes = [] # TODO

      assert string.bytes == expected_bytes
    end
  end

  describe 'ISO-8859-1' do
    # https://en.wikipedia.org/wiki/ISO/IEC_8859-1#Code_page_layout
    ISO_8859_1 = Encoding::ISO_8859_1

    specify 'bytes to ISO-8859-1 string' do
      skip

      bytes = [0x63, 0x61, 0x66, 0xE9]
      expected_string = ''.encode(ISO_8859_1) # TODO

      assert string_from_bytes(bytes, encoding: ISO_8859_1) == expected_string
    end

    specify 'ISO-8859-1 string to bytes' do
      skip

      string = '£50'.encode(ISO_8859_1)
      expected_bytes = [] # TODO

      assert string.bytes == expected_bytes
    end
  end
end

# https://docs.ruby-lang.org/en/3.1/Array.html#method-i-pack
BYTES_PACK_TEMPLATE = 'C*' # zero or more unsigned 8-bit integers

def string_from_bytes(bytes, encoding:)
  bytes.pack(BYTES_PACK_TEMPLATE).force_encoding(encoding)
end
