# Class for storing discounts.
class Discounts
  # The hash stores two types of discounts for each item type. The default discount will be 'n for m' discount rather than percentage discount.
  # Apply the discount_hash rules as follows:
  # * if charge_count is specified and count is set to :count, charge for :charge_count items
  # * if percentage_discount is specified, set it as the discount for every item, until offer_restriction_count is reached 
  def self.discounts_hash
    {:mango => 
      {:count => 4, :charge_count => 3, :percentage_discount => nil, :offer_restriction_count => nil},
    :apple => 
      {:count => 2, :charge_count => 1, :percentage_discount => nil, :offer_restriction_count => nil},
    :pear => 
      {:count => 2, :charge_count => 1, :percentage_discount => nil, :offer_restriction_count => nil},
    :banana => 
      {:count => 1, :charge_count => nil, :percentage_discount => 0.5, :offer_restriction_count => nil},
    :pineapple => 
      {:count => 1, :charge_count => nil, :percentage_discount => 0.5, :offer_restriction_count => 1}
    }
  end
end
