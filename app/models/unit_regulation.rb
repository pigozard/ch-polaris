class UnitRegulation < ApplicationRecord
  belongs_to :unit

  serialize :forbidden_items, coder: JSON
  serialize :allowed_items, coder: JSON
end
