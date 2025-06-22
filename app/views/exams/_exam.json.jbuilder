# frozen_string_literal: true

json.extract! exam, :id, :weight, :name, :score, :created_at, :updated_at
json.url exam_url(exam, format: :json)
