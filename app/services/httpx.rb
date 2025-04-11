module Httpx
  module_function
  def get(url, params: {})
    HTTP.get(url, params: params) # steep:ignore
  end
end
