require File.expand_path '../../../helper.rb', __FILE__

describe 'Users' do
  let(:user) { User.spawn }

  let(:attrs) do
    [
      :first_name,
      :last_name,
      :email
    ]
  end

  let(:valid_attributes) do
    {
      first_name: 'Juan',
      last_name: 'Perez',
      email: 'juanperez@example.com',
      password: 'secret',
      password_confirmation: 'secret'
    }
  end

  let(:us_user) { User.spawn }

  describe 'User' do
    it 'POST /api/v1/auth/signup' do
      post('/api/v1/auth/signup', valid_attributes)
      assert_equal 201, last_response.status
    end

    it 'PUT /api/v1/users' do
      current_user = user
      put('/api/v1/users', valid_attributes,
          'HTTP_X_PAYE_APPLICATION-NAME_ACCESS_TOKEN' => current_user.access_token)

      result = JSON.parse(last_response.body)

      assert_equal 200, last_response.status
      assert_equal result.slice(attrs), valid_attributes.slice(attrs)
    end
  end
end
