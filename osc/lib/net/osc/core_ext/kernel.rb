module Kernel
  def returning(value)
    yield
    value
  end
end
