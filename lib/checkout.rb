
# Class for scanning and calculating the total price in the basket.
class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices = nil)
    @prices = prices || Prices.prices_hash
  end

  def scan(item)
    # Only add items to basket if scan method returns successfully. Ignore unknown items.
    raise InvalidItemError.new, "Unknown item #{item} scanned" if !@prices.include?(item)
    basket << item.to_sym
  end

  def total
    total = 0
    if !@prices || !@prices.is_a?(Hash)
      raise UnknownPricesError.new, "Prices have not been defined"
    end
    
    basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }.each do |item, count|
      pc = PriceCalculator.new(@prices)
      total += pc.get_total_price_for_items(item, count)
    end
    total
  end

  private

  def basket
    @basket ||= []
  end
end

class InvalidItemError < StandardError
end

class UnknownPricesError < StandardError
end
