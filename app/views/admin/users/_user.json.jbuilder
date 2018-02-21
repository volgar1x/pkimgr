json.extract! user, :id, :email, :firstname, :lastname, :street, :street2, :city, :zip, :country, :phone, :created_at, :updated_at
json.url user_url(user, format: :json)
