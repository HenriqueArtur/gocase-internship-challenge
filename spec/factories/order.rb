purchase_channel_array = [
    ['Site BR', 'BR', 'R$ ', ['SEDEX', 'PAC']],
    ['Site EN', 'EN', '$ ', ['FEDEX']],
    ['Site DE', 'DE', '€ ', ['EUROSENDER', 'deSENDER']],
    ['Site FR', 'FR', '€ ', ['EUROSENDER', 'frSENDER']],
    ['Site IT', 'IT', '€ ', ['EUROSENDER', 'itSENDER']],
    ['Iguatemi Store', 'BR', 'R$ ', ['SEDEX', 'PAC']]
  ]
  
  line_items_array = [
    ['[{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}]', '100.00'],
    ['[{sku: powebank-sunshine, capacity: 10000mah}]', '230.00'],
    ['[{sku: earphone-standard, color: white}]', '50.00'],
    ['[{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, {sku: powebank-sunshine, capacity: 10000mah}]', '330.00'],
    ['[{sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}]', '280.00'],
    ['[{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, {sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}]', '480.00']
  ]
  
  pcSample = purchase_channel_array.sample
  liArray = line_items_array.sample

  FactoryBot.define do
    factory :order do
      reference {pcSample[1] + sprintf('%06i', Order.maximum(:id) == nil ? 1 : Order.maximum(:id).next)}
      purchase_channel {pcSample[0]}
      client_name {Faker::Games::HalfLife.character}
      address {Faker::Address.full_address}
      delivery_service {pcSample[3].sample}
      total_value {pcSample[2] + liArray[1]}
      line_items {liArray[0]}
      status {"ready"}
    end
  end