require_relative 'api'

class APIRoutes
  class V1
    #:nodoc:
    class UserRoutes < Cuba
      define do
        on put do
          user_test = Validators::EditUser.new(req.params)
          if user_test.valid?
            user = User[current_user_id]
            attrs = user_test.attributes
            attrs.delete(:password_confirmation)
            user.update(attrs)
            json(user)
          else
            api_unprocessable!(user_test)
          end
        end
      end
    end
  end
end
