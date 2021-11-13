class PriceCalculator
    
  def initialize(prices)
    @total = 0
    @prices = prices
  end
  
  # Calculate a price for and item 
  def get_total_price_for_items(item, count)
    discounts = Discounts.discounts_hash[item] || {}
    
    # Apply 'n for m' rule:
    price = @prices[item]
    if discounts[:charge_count]
      no_of_iterations = count / discounts[:count]
      no_of_iterations = [no_of_iterations, discounts[:offer_restriction_count]].min if discounts[:offer_restriction_count]
      remaining_items = count - (no_of_iterations * discounts[:count])
      
      @total += no_of_iterations * (discounts[:charge_count] * price)
      @total += price * remaining_items
    # Apply percentage discount:
    elsif discounts[:percentage_discount]
      no_of_iterations = discounts[:offer_restriction_count] ? discounts[:offer_restriction_count] : count
      remaining_items = count - no_of_iterations
      
      @total += no_of_iterations * ((1 - discounts[:percentage_discount]) * price)
      @total += price * remaining_items
    else
      @total += price * count
    end
    
  end
end
