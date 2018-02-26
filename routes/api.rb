# :nodoc:
class APIRoutes < Cuba
  define do
    res.headers['Content-Type'] = 'application/json'
    res.headers['X-Whoami']     = 'PayeAPPLICATION-NAME API'

    on 'v1' do
      on 'auth' do
        run APIRoutes::Auth
      end

      authenticate!

      run APIRoutes::V1
    end

    api_not_found!
  end
end
