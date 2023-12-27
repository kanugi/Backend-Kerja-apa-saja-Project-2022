require 'jwt'

module JsonWebToken extend ActiveSupport::Concern

  SECRET_KEY = "secret"

  def jwt_encode(payload, exp)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def access_token_encode(payload)
    exp = 1.days.from_now
    jwt_encode(payload, exp)
  end

  def refresh_token_encode(payload)
    exp = 2.days.from_now
    jwt_encode(payload, exp)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
