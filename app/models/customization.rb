class Customization < ActiveRecord::Base
  validates :spree_variable, :arp_id, :value, presence: true
end
