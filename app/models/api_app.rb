class ApiApp < ActiveRecord::Base
  attr_accessible :contact, :ip_address, :name
  attr_reader :auth_message

  # Authentication using rails has_secure_password with bcrypt password_digest
  # `password` is aliased as `app_secret` (it is a better name in the API)
  has_secure_password
  alias_attribute :app_secret, :password

  before_validation :generate_app_token, :generate_app_secret, on: :create
  validates_presence_of :name, :contact, :ip_address

  def self.authenticate(app_token, app_secret, ip_address)
    app = where(app_token: app_token, ip_address: ip_address).first
    app && app.authenticate(app_secret)
  end

  def generate_app_secret
    self.password = SecureRandom.hex
  end

  private
   # Generate a unique app_token
    def generate_app_token
      begin
        self.app_token = SecureRandom.hex
      end while self.class.exists?(app_token: app_token)
    end
end
