# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
categories = [
  "通行規制",
  "落石・土砂流入等",
  "落下物",
  "路面異常",
  "構造物の損傷",
  "事故",
  "動物の死骸",
  "その他"
]
categories.each do |category_name|
    Category.find_or_create_by(name: category_name)
end