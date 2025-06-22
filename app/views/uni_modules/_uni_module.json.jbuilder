# frozen_string_literal: true

json.extract! uni_module, :id, :code, :name, :created_at, :updated_at
json.url uni_module_url(uni_module, format: :json)
