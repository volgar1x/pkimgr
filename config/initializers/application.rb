# Used right now to encrypt PEM files
blocklen = ["AES-512", "AES-256", "AES-192", "AES-128"]
ciphermode = ["CTR", "CBC"]
ciphernames = blocklen.product(ciphermode).map{|x| x.join("-")}
for ciphername in ciphernames
  begin
    Rails.application.config.cipher = OpenSSL::Cipher.new ciphername
    break
  rescue RuntimeError
    # continue
  end
end
raise "no cipher available" unless Rails.application.config.try(:cipher)

# Do not output <div class="field_with_errors">...</div>
Rails.application.config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
