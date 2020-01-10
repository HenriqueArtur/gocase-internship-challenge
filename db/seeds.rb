# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

pcArray = [['Site BR', 'BR', 'SEDEX'], ['Site EU', 'EU', 'FEDEX'], ['Site US', 'US', 'EUROSENDER']]

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
        status: 'Ready'
    })
end