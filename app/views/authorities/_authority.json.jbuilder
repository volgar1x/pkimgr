json.extract! authority, :id, :name, :email, :website, :sign_key_pem, :encrypt_key_pem, :created_at, :updated_at
json.url authority_url(authority, format: :json)
