class ChangeDealsCurrencyType < ActiveRecord::Migration
  def up
    change_column :deals, :currency, :string
    Deal.where(:currency => '0').update_all(:currency => 'USD')
    Deal.where(:currency => '1').update_all(:currency => 'EUR')
    Deal.where(:currency => '2').update_all(:currency => 'GBP')
    Deal.where(:currency => '3').update_all(:currency => 'RUB')
    Deal.where(:currency => '4').update_all(:currency => 'JPY')
    Deal.where(:currency => '5').update_all(:currency => 'INR')
    Deal.where(:currency => '6').update_all(:currency => 'PLN')
  end

  def down
  end
end
