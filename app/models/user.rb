class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :years, dependent: :destroy
  has_many :exams, through: :exam_results
  has_many :uni_modules, through: :uni_module_targets
  has_many :timelogs, dependent: :destroy
  
end
