# frozen_string_literal: true

class UniModuleTarget < ApplicationRecord
  belongs_to :user
  belongs_to :uni_module
end
