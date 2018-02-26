module StringExtension
  def present?
    !blank?
  end

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

String.__send__(:include, StringExtension)
NilClass.__send__(:include, StringExtension)
