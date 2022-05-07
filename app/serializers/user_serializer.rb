class UserSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :dash

  attributes(
    :name,
    :email,
    :created_at,
    :updated_at
  )
end
