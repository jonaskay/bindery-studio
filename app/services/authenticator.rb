class Authenticator
  class Error < StandardError; end

  include Singleton

  def self.access_token(bearer)
    if (capture = /^Bearer (\S+)/.match(bearer))
      return capture[1]
    end

    raise Authenticator::Error.new("Bearer token is invalid")
  end

  def self.validate_token(token, *args)
    validator = args[0] || instance.validator

    begin
      validator.check(token, ENV.fetch("HOST"))
      return true
    rescue GoogleIDToken::ValidationError => err
      return false
    end
  end

  def validator
    @validator ||= GoogleIDToken::Validator.new
  end
end
