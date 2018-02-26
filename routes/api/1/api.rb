require_relative 'api'
class APIRoutes
  # Routes /api/v1
  class V1 < Cuba
    define do
      # Routes /api/v1/users
      on 'users' do
        run UserRoutes
      end

    end
  end
end
