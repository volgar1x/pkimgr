require 'io/console'
class IO
  def prompt(msg, stdout=STDOUT)
    stdout.write msg
    self.gets.strip
  end
end

if Rails.env == "production"
  user = User.create! email: STDIN.prompt("Enter admin email: "),
                      password: STDIN.getpass("Enter admin password: "),
                      firstname: STDIN.prompt("Enter admin first name: "),
                      lastname: STDIN.prompt("Enter admin last name: "),
                      admin: true
else
  user = User.create email: "test@test", password: "test", country: "FR", state: "Haute-Normandie", city: "Rouen", zip: "76000", admin: true

  user.authorities.create([
    { name: "Hello1", email: "hello1@hello.hello", website: "http://hello1.hello", password: "hello", country: "FR", state: "Haute-Normandie", city: "Rouen", zip: "76000", organization: "Universite de Rouen" },
    { name: "Hello2", email: "hello2@hello.hello", website: "http://hello2.hello", password: "hello", country: "FR", state: "Haute-Normandie", city: "Rouen", zip: "76000", organization: "Universite de Rouen" },
    { name: "Hello3", email: "hello3@hello.hello", website: "http://hello3.hello", password: "hello", country: "FR", state: "Haute-Normandie", city: "Rouen", zip: "76000", organization: "Universite de Rouen" },
  ])
end

p1 = CertProfile.create name: "Authority"
p1.constraints.create(type: "add_extension", value: {"oid" => "subjectKeyIdentifier", "value" => "hash"})
p1.constraints.create(type: "add_extension", value: {"oid" => "authorityKeyIdentifier", "value" => "keyid:always"})
p1.constraints.create(type: "add_extension", value: {"oid" => "basicConstraints", "value" => "CA:TRUE, pathlen:1", "critical" => true})
p1.constraints.create(type: "add_extension", value: {"oid" => "keyUsage", "value" => "cRLSign,keyCertSign"})

p2 = CertProfile.create name: "Intermediate Authority"
p2.constraints.create(type: "add_extension", value: {"oid" => "basicConstraints", "value" => "CA:TRUE, pathlen:0", "critical" => true})
p2.constraints.create(type: "add_extension", value: {"oid" => "subjectKeyIdentifier", "value" => "hash"})
p2.constraints.create(type: "add_extension", value: {"oid" => "authorityKeyIdentifier", "value" => "keyid:always,issuer:always"})
p2.constraints.create(type: "add_extension", value: {"oid" => "keyUsage", "value" => "cRLSign,keyCertSign"})

p3 = CertProfile.create name: "Web Server (Nginx, Apache, ...)"
p3.constraints.create(type: "add_extension", value: {"oid" => "subjectKeyIdentifier", "value" => "hash"})
p3.constraints.create(type: "add_extension", value: {"oid" => "authorityKeyIdentifier", "value" => "keyid:always,issuer:always"})
p3.constraints.create(type: "add_extension", value: {"oid" => "basicConstraints", "value" => "CA:FALSE"})
p3.constraints.create(type: "add_extension", value: {"oid" => "nsCertType", "value" => "server"})
p3.constraints.create(type: "add_extension", value: {"oid" => "keyUsage", "value" => "digitalSignature, nonRepudiation"})
p3.constraints.create(type: "add_extension", value: {"oid" => "extendedKeyUsage", "value" => "serverAuth,clientAuth"})

p4 = CertProfile.create name: "OpenVPN Server"
p4.constraints.create(type: "add_extension", value: {"oid" => "subjectKeyIdentifier", "value" => "hash"})
p4.constraints.create(type: "add_extension", value: {"oid" => "authorityKeyIdentifier", "value" => "keyid:always,issuer:always"})
p4.constraints.create(type: "add_extension", value: {"oid" => "basicConstraints", "value" => "CA:FALSE"})
p4.constraints.create(type: "add_extension", value: {"oid" => "nsCertType", "value" => "server"})
p4.constraints.create(type: "add_extension", value: {"oid" => "nsComment", "value" => "OpenVPN Server"})
p4.constraints.create(type: "add_extension", value: {"oid" => "keyUsage", "value" => "digitalSignature, nonRepudiation"})
p4.constraints.create(type: "add_extension", value: {"oid" => "extendedKeyUsage", "value" => "serverAuth"})

p5 = CertProfile.create name: "OpenVPN Client"
p5.constraints.create(type: "add_extension", value: {"oid" => "subjectKeyIdentifier", "value" => "hash"})
p5.constraints.create(type: "add_extension", value: {"oid" => "authorityKeyIdentifier", "value" => "keyid:always,issuer:always"})
p5.constraints.create(type: "add_extension", value: {"oid" => "basicConstraints", "value" => "CA:FALSE"})
p5.constraints.create(type: "add_extension", value: {"oid" => "nsCertType", "value" => "client"})
p5.constraints.create(type: "add_extension", value: {"oid" => "nsComment", "value" => "OpenVPN Client"})
p5.constraints.create(type: "add_extension", value: {"oid" => "keyUsage", "value" => "digitalSignature, nonRepudiation"})
p5.constraints.create(type: "add_extension", value: {"oid" => "extendedKeyUsage", "value" => "clientAuth"})

