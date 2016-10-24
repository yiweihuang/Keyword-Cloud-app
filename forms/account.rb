require 'dry-validation'

LoginCredentials = Dry::Validation.Form do
  key(:account).required
  key(:password).required
end
