require_relative '../api'
class APIRoutes
  # Auth Routes without credentials
  class Auth < Cuba
    define do
      # Routes /api/v1/auth
      on post do
        # Routes [POST] /api/v1/login
        on 'login' do
          user = User.authenticate(req.params['username'],
                                   req.params['password'])
          if user
            json(authenticated: !user.nil?, user: user)
          else
            api_not_found!
          end
        end

        # Routes [POST] /api/v1/signup
        on 'signup' do
          signup = Validators::SignUp.new(req.params)
          if signup.valid?
            User.create(
              signup.slice(:first_name, :last_name,
                           :email, :password)
            )
            api_created!
          else
            api_unprocessable!(signup)
          end
        end
      end
    end
  end
end
