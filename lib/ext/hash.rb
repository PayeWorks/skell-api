class Hash
  def except(*keys)
    dup.delete_if {|key, _| keys.include?(key)}
  end

  def slice(*attributes)
    attributes = attributes.map(&:to_s)
    self.select { |k, _| attributes.include?(k) }
  end
end