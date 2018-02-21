class MiscController < SecureController
  def dashboard
    @versions = {
      openssl: OpenSSL::OPENSSL_VERSION.split(' ')[1],
      ruby: "#{Object::RUBY_ENGINE} #{Object::RUBY_ENGINE_VERSION}",
      rails: Rails.version,
      postgres: postgres_version,
    }
  end

  private
    def postgres_version
      v = ApplicationRecord.connection.postgresql_version
      [
        v / 100_00,
        v / 100 % 100,
        v % 100,
      ].join(".")
    end
end
