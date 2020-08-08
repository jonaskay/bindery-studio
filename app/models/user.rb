class User < ApplicationRecord
  self.implicit_order_column = "created_at"

  has_many :projects, dependent: :destroy

  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable
end
