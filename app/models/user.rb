class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Pas de :registerable : aucune inscription publique, les comptes (admin, secrétaire)
  # seront créés à la main quand le back-office existera (étape 3).
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
