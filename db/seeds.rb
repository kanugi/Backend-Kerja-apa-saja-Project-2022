# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

categories = [
   {
     name: "Pertanian"
   },
   {
     name: "Peternakan"
   },
   {
     name: "Perikanan"
   },
   {
     name: "Komputer dan Teknologi"
   },
   {
     name: "Jasa"
   },
   {
     name: "Kesehatan"
   },
   {
     name: "Pendidikan"
   },
   {
     name: "Pariwisata"
   },
   {
     name: "Pertambangan"
   },
   {
     name: "Industri"
   },
   {
     name: "Konstruksi"
   },
   {
     name: "Perdagangan"
   },
   {
     name: "Transportasi"
   },
   {
     name: "Pemerintahan"
   },
]

categories.each do |category|
  Category.find_or_create_by(name: category[:name])
end