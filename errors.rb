class InvalidAlphabet < StandardError
  def initialize(msg='Invalid Alphabet')
    super
  end
end

class InvalidPlainText < StandardError
  def initialize(msg='Invalid plain text')
    super
  end
end

class InvalidSecretKey < StandardError
  def initialize(msg='Invalid secret key')
    super
  end
end