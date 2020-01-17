FactoryBot.define do
  factory :batch do
    reference {Date.today.year.to_s << sprintf('%02i', Date.today.month) << '-' << sprintf('%02i', Batch.maximum(:id) == nil ? 1 : Batch.maximum(:id).next)}
    purchase_channel {['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store'].sample}
  end
end