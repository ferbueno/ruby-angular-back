json.user do
    json.extract! user, :id, :username, :email
end

json.token token
