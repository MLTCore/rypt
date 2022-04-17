require_relative 'errors'
require_relative 'alphabets'

# Base class for all ciphers
class Cipher
	attr_accessor :plain_text, :result_text, :secret_key
  attr_accessor :alphabet, :ignore_alphabet

  @@base_plain_text      = ''
  @@base_secret_key      = ''
  @@base_alphabet        = ENG_ALPH
  @@base_ignore_alphabet = PUNC_ALPH

	def initialize(plain_text: '', secret_key: '', alphabet: '', ignore_alphabet: '')
		@plain_text      = if plain_text.empty?      then @@base_plain_text      else plain_text      end
		@secret_key      = if secret_key.empty?      then @@base_secret_key      else secret_key      end
		@alphabet        = if alphabet.empty?        then @@base_alphabet        else alphabet        end
    @ignore_alphabet = if ignore_alphabet.empty? then @@base_ignore_alphabet else ignore_alphabet end
    @result_text     = ''
	end

  def cipher_encrypt
    raise NotImplementedError, 'You must implement the encrypt method' 
  end

  def cipher_decrypt
    raise NotImplementedError, 'You must implement the decrypt method'
  end

  protected :cipher_encrypt, :cipher_decrypt

	def encrypt
    @result_text = ''
    raise InvalidPlainText if plain_text.empty?
    raise InvalidSecretKey if secret_key.to_s.empty? 
    raise InvalidAlphabet unless correct_alphabet?
		cipher_encrypt
    @result_text
	end

	def decrypt
    @result_text = ''
    raise InvalidPlainText if plain_text.empty?
    raise InvalidSecretKey if secret_key.to_s.empty? 
    raise InvalidAlphabet  unless correct_alphabet?
    cipher_decrypt
    @result_text
	end

	def correct_alphabet?
		raise NotImplementedError, 'You must implement the correct_alphabet method'
	end

  def correct_secret_key?
    raise NotImplementedError, 'You must implement the correct_secret_key method'
  end

	def load_from_file(file_path)
		@plain_text = File.read(file_path).split('\n')
	end

	def save_to_file(file_path)
		File.write(file_path, @result_text)
	end

	def encrypt_file(file_path)
		load_from_file(file_path)
		encrypt
		save_to_file(file_path)
	end

	def decrypt_file(file_path)
		load_from_file(file_path)
		decrypt
		save_to_file(file_path)
	end

	def encrypt_str(str)
		@plain_text = str
		encrypt
		@result_text
	end

	def decrypt_str(str)
		@plain_text = str
		decrypt
		@result_text
	end

  def swap
    @plain_text, @result_text = @result_text, @plain_text
    @plain_text
  end
end

# Class for asymmetric ciphers
class AsymCipher < Cipher
	attr_accessor :open_key

	def initialize(plain_text: '', secret_key: '', open_key: '', alphabet: '', ignore_alphabet: '')
		super(plain_text, secret_key, alphabet, ignore_alphabet)
		@open_key = open_key
	end
end

# Class for symmetric ciphers
class SymCipher < Cipher
end