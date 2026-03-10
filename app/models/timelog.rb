# frozen_string_literal: true

class Timelog < ApplicationRecord
  belongs_to :uni_module
  belongs_to :user, touch: true

  scope :for_user, ->(user) { where(user_id: user.id) }
end
