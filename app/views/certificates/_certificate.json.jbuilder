json.extract! certificate, :id, :issuer_id, :subject_id, :profile_id, :pem, :revoked_at, :created_at, :updated_at
json.url certificate_url(certificate, format: :json)
