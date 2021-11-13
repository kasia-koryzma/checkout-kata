## Refactoring steps 

Added Prices class with a class method to represent scannable items and their prices. The prices can be overridden within a checkout class.

Added Discounts class with a class method for representing different discounts for a scannable item. The hash representing discounts can be read as:
- if :charge_count is defined for an item type, it follows 'buy n items, pay for m items' type of offer. :charge_count defines the number of items the customer will be charged for and :count the number of items the customer had scanned.
The type of offer applies to the hardcoded offer for apples and pears in the original Checkout#total method (i.e. buy two pay for 1) as well as offer for mangoes.
-- if :percentage_discount is set, apply the discount to the item(s) scanned. 
- :offer_restriction_count defines how many times the offer can be applied (if nil, the discount can be applied to any number of items of the selected type). This type of offer applies to hardcoded discount defined for pineapples within Checkout#total method.

Created PriceCalculator class responsible for working out the total price for items of specific type and quantity. The method takes into consideration any discounts defined within Discounts#discounts_hash. The total price uses either the pre-defined prices or overridden ones passed in from checkout instance.

Checkout#total method - removed the hardcoded logic for defining discounts for apples, pears, pineapples and bananas to Discounts#discounts_hash. 
The method now calculates the total price for item type given the quantity using PriceCalculator#get_total_price_for_items method.
For every instance of the checkout, the total is reset to 0 and the current prices list passed in.

## Error handling
- Only items that are present in the @prices variable (either pre-defined or overridden hash) can be scanned successfully. If the item to be scanned is not valid, an InvalidItemError is thrown. Invalid item scan does not affect the content of the basket.

## Design decisions
The functionality is divided into two parts, each implemented in a separate class:
- Scanning items, adding valid items into the basket and working out the total price 
- Working out the total price for an item type, based on the quantity scanned and discounts that can be applied.

### Limitations and possible Improvements
- The discounts that can be applied are predefined within #Discounts class and cannot be changed (as the requirement is to read the discount from the database/hash). It would be ideal to have an ability to override the default discount for an item type.
- The definition of Discounts allows to define either a 'n for m' or percentage discount. Whilst this might be sufficient in most cases, it is not exhaustive therefore limited. Also, if both of the types of discount are defined for an item type, the first one will be selected which might not necessarily be the best one. Having two different types of discounts for one item is very unusual hence why 'best discount' methodology has not been implemented.  
- Every time the total is called for a checkout, the total is recalculated for all items. It might be better, performance wise, to recalculate the total for newly scanned items and add it to the totals for other items.
- There's no way to clear the basket/delete an item. Methods to achieve this should exist.
- There's no logging. 

### The following files have been changed:
- lib/checkout.rb
- spec/checkout_spec.rb

### The following files have been added:
- lib/discounts.rb
- lib/price_calculator.rb
- lib/prices.rb

All other files exist as the original copies.
