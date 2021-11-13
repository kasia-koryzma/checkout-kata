require_relative 'lib/checkout'
require_relative 'lib/price_calculator'
require_relative 'lib/prices'
require_relative 'lib/discounts'

RSpec.describe Checkout do
  describe '#total' do
    subject(:total) { checkout.total }

    let(:checkout) { Checkout.new(pricing_rules) }
    let(:pricing_rules) {
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200
      }
    }

    context 'when no offers apply' do
      before do
        checkout.scan(:apple)
        checkout.scan(:orange)
      end

      it 'returns the base price for the basket' do
        expect(total).to eq(30)
      end
    end

    context 'when a two for 1 applies on apples' do
      before do
        checkout.scan(:apple)
        checkout.scan(:apple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(10)
      end

      context 'and there are other items' do
        before do
          checkout.scan(:orange)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a two for 1 applies on pears' do
      before do
        checkout.scan(:pear)
        checkout.scan(:pear)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end

      context 'and there are other discounted items' do
        before do
          checkout.scan(:banana)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a half price offer applies on bananas' do
      before do
        checkout.scan(:banana)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end
    end

    context 'when a half price offer applies on pineapples restricted to 1 per customer' do
      before do
        checkout.scan(:pineapple)
        checkout.scan(:pineapple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(150)
      end
    end

    context 'when a buy 3 get 1 free offer applies to mangos' do
      before do
        4.times { checkout.scan(:mango) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(600)
      end
    end
    
    context 'when a two for 1 applies on apples in multiples' do
      before do
        6.times { checkout.scan(:apple) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(30)
      end

      context 'and there is another apple added to which no discount applies' do
        before do
          checkout.scan(:apple)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(40)
        end
      end
    end
    
    context 'when a half price offer applies on bananas and there are multiples of them' do
      before do
        3.times { checkout.scan(:banana) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(45)
      end
    end
    
    context 'when a half price offer applies on pineapples restricted to 1 per customer and there are multiples of them' do
      before do
        5.times { checkout.scan(:pineapple) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(450)
      end
    end
    
    context 'when a buy 3 get 1 free offer applies to mangos and there are multiples of them' do
      before do
        10.times { checkout.scan(:mango) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(1600)
      end
    end
    
    context 'when multiple different items are in the basket and offers apply to some of them' do
      before do
        # two mangoes should cost 400 
        2.times { checkout.scan(:mango) }
        # three pineapples should cost 250 
        3.times { checkout.scan(:pineapple) }
        # four pears should cost 30 
        4.times { checkout.scan(:pear) }
        # a banana should cost 15 
        checkout.scan(:banana)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(695)       
      end
    end
  end
end
