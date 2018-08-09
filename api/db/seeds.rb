log = JSON.parse(File.read("#{Rails.root}/data/log.json"))
counter = 0
log.each do |row|
  Log.create(row.to_h)
  counter += 1
  puts counter
end

puts "Seed complete. Added #{Log.all.size} rows to db."
