# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

admin = User.create(email: 'admin@gmail.com',
                    password: '123456',
                    password_confirmation: '123456',
                    address: 'afdfasfdafsdfd',
                    phone_number: '081234123214',
                    firstname: 'admin',
                    lastname: 'admin',
                    name_prefix: 'Mr.',
                    admin: true)

user1 = User.create(email: 'ws.kandith@gmail.com',
                    password: '123456',
                    password_confirmation: '123456',
                    address: 'afdfasfdafsdfd',
                    phone_number: '0891438432',
                    firstname: 'Kandith',
                    lastname: 'Wongsuwan',
                    name_prefix: 'Mr.',
                    admin: false)

