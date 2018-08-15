log = JSON.parse(File.read("#{Rails.root}/data/log.json"))
counter = 0
log.each do |row|
  @new_entry = Log.new(
    component_name: row["component_name"],
    component_type: row["component_type"],
    location: row["location"],
    status: row["status"],
    change_ts: Helper.convert_ms_to_datetime(row["change_ts"])
  )

  if @new_entry.save
    counter += 1
    puts counter
  else
    puts "Record skipped"
  end
end

puts "Seed complete. Added #{Log.all.size} rows to db."
