 Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String :first_name
      String :last_name
      String :email
      Integer :account_id
      Integer :user_type
      String :access_token
      String :crypted_password

      DateTime :created_at
      DateTime :updated_at

      index :account_id
      index :email, unique: true
      index :access_token, unique: true
    end
  end
end
