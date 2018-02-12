class MiscController < SecureController
  def dashboard
    @versions = {
      openssl: OpenSSL::OPENSSL_VERSION.split(' ')[1],
      ruby: `ruby -v`.split(' ')[1],
      rails: `rails -v`.split(' ')[1],
      postgres: `psql -V`.split(' ')[2],
    }
  end
end
