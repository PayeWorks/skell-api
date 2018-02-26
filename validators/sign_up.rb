module Validators
  # SignUp Class validation
  class SignUp < Scrivener

    attr_accessor :first_name
    attr_accessor :last_name
    attr_accessor :email
    attr_accessor :password
    attr_accessor :password_confirmation

    def validate
      assert_present(:first_name)
      assert_present(:last_name)
      assert_present(:email)
      assert_present(:password) &&
        assert_equal(:password, password_confirmation)
      assert_length :password, 6..20
      assert_email(:email)
    end
  end
end
