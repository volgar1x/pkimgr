class MiscController < SecureController
  def dashboard
    @versions = {
      openssl: OpenSSL::OPENSSL_VERSION.split(' ')[1],
      ruby: `ruby -v`.try(:split).try(:at, 1) || "unknown",
      rails: `rails -v`.try(:split).try(:at, 1) || "unknown",
      postgres: `postgres -V`.try(:split).try(:at, 2) || "unknown",
    }
  end
end
