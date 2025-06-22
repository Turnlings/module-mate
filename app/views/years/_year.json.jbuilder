# frozen_string_literal: true

json.extract! year, :id, :created_at, :updated_at
json.url year_url(year, format: :json)
