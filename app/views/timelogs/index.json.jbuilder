# frozen_string_literal: true

json.array! @timelogs, partial: 'timelogs/timelog', as: :timelog
