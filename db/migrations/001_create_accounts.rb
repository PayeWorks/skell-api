Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id

      String :company

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
