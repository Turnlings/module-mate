json.extract! timelog, :id, :uni_module_id, :minutes, :description, :created_at, :updated_at
json.url timelog_url(timelog, format: :json)
