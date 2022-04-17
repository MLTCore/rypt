require_relative '../cipher'
require_relative '../alphabets'

class CeasarCipher < SymCipher
  def initialize(plain_text: '', secret_key: '', alphabet: '', ignore_alphabet: '')
    super
    @secret_key = @secret_key.to_i 
  end

  def cipher_encrypt
    @plain_text.each_char do |symb|
      if @ignore_alphabet.include? symb
        @result_text += symb
        next
      end

      new_index = (@alphabet.index(symb) + @secret_key) % @alphabet.length
      @result_text += @alphabet[new_index]
    end
  end

  def cipher_decrypt
    @plain_text.each_char do |symb|
      if @ignore_alphabet.include? symb
        @result_text += symb
        next
      end

      new_index = (@alphabet.index(symb) - @secret_key+1) % @alphabet.length
      @result_text += @alphabet[new_index]
    end
  end

	def correct_alphabet?
    @plain_text.each_char do |symb|
      return false if !(alphabet.include?(symb) || ignore_alphabet.include?(symb))
    end
    true
	end

  def correct_secret_key?
    !@secret_key.to_s.empty? && @secret_key.scan(/\D/).empty?
  end
end

class GronsfeldCipher < CeasarCipher

  def initialize(plain_text: '', secret_key: '', alphabet: '', ignore_alphabet: '')
    super
    @secret_key = @secret_key.to_s
  end

  def cipher_encrypt 
    @plain_text.each_char.with_index do |symb, ind|
      if @ignore_alphabet.include? symb
        @result_text += symb
        next
      end

      new_index = (@alphabet.index(symb) + secret_key[ind % secret_key.length].to_i) % alphabet.length
      @result_text += @alphabet[new_index]
    end
  end

  def cipher_decrypt
    @plain_text.each_char.with_index do |symb, ind|
      if @ignore_alphabet.include? symb
        @result_text += symb
        next
      end

      new_index = (@alphabet.index(symb) - secret_key[ind % secret_key.length].to_i) % @alphabet.length
      @result_text += @alphabet[new_index]
    end
  end
end

class VigenereCipher < GronsfeldCipher

  def cipher_encrypt
    @plain_text.each_char.with_index do |symb, ind|
      if @ignore_alphabet.include? symb
        @result_text += symb
        next
      end

      new_index = (@alphabet.index(symb) + @alphabet.index(@secret_key[ind % secret_key.length])) % @alphabet.length
      @result_text += @alphabet[new_index]
    end
  end

  def cipher_decrypt
    @plain_text.each_char.with_index do |symb, ind|
      if @ignore_alphabet.include? symb
        @result_text += symb
        next
      end

      new_index = (@alphabet.index(symb) - @alphabet.index(@secret_key[ind % secret_key.length])) % @alphabet.length
      @result_text += @alphabet[new_index]
    end
  end

  def correct_secret_key?
    !@secret_key.empty? && @secret_key.scan(/\W/).empty?
  end
end