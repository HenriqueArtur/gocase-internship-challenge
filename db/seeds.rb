pcArray = [['Site BR', 'BR', 'SEDEX'], ['Site EU', 'EU', 'EUROSENDER'], ['Site US', 'US', 'FEDEX']]
status = ['ready', 'production', 'closing', 'sent']

10.times do
    sample =  pcArray.sample
    Order.create({
        reference: sample[1] + rand(100000..999999).to_s,
        purchase_channel: sample[0],
        client_name: Faker::Games::Witcher.character,
        address: Faker::Address.full_address,
        delivery_service: sample[2],
        total_value: "R$ " + rand(100..500).to_s + ",00",
        line_items: "[{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, {sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}]",
        status: status.sample
    })
end