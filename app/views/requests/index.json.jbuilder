json.array!(@requests) do |request|
  json.extract! request, :id, :employee, :machine, :description
  json.url request_url(request, format: :json)
end
