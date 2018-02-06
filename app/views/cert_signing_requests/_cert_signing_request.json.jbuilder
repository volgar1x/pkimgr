json.extract! cert_signing_request, :id, :subject_id, :subject_type, :profile_id, :pem, :created_at, :updated_at
json.url cert_signing_request_url(cert_signing_request, format: :json)
