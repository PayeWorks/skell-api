# require 'enumeration'

class UserRole < Enumeration
  self.add_item(:SUPERADMIN, 0)
  self.add_item(:ADMIN, 10)
  self.add_item(:OPERATOR, 20)
  self.add_item(:OPERATOR_RESTRICTED, 25)
  self.add_item(:GUEST, 30)

  def self.can_access?(role, user_role)
    raise ArgumentError, 'Roles Error: both argument must be roles.' unless [role, user_role].map(&:upcase).to_set.subset?(self.keys.map(&:to_s).to_set)

    @hash[user_role.upcase.to_sym] <= @hash[role.upcase.to_sym]
  end
end
