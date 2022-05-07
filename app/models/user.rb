class User < ApplicationRecord
  has_many :access_grants,
    class_name: 'Doorkeeper::AccessGrant',
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
    class_name: 'Doorkeeper::AccessToken',
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks
  has_secure_password

  def authenticate!(password)
    if self.authenticate(password)
      true
    else
      throw 'incorrect password'
    end
  end
end
