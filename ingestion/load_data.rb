require 'sqlite3'
require 'csv'

def convert_currency(value)
	# convert currency text values to float
	return value.gsub('$', '').to_f
end

def scrub_text(text)
	# scrub text for escape chars and caps
	return text.gsub("'", "\'").gsub('"', "\'").downcase
end

begin
	db = SQLite3::Database.open 'beer.db'
	puts "Cleaning up old table"
	db.execute "DROP TABLE IF EXISTS employee_earnings;"
	puts "Creating table"
	db.execute "CREATE TABLE IF NOT EXISTS employee_earnings(id INTEGER PRIMARY KEY, 
		name TEXT, title TEXT, department TEXT, regular REAL, retro REAL, 
		other REAL, overtime REAL, injured REAL, detail REAL, quinn REAL,
		total_earnings REAL, zip TEXT);"

	db.transaction
	id_count = 0
	puts "Writing data to table"
	earnings = CSV.read('beer2014.csv')
	for row in earnings[1..-1] do
		sql = "INSERT INTO employee_earnings VALUES(#{id_count}, 
			\"#{scrub_text(row[0])}\", \"#{scrub_text(row[1])}\", \"#{scrub_text(row[2])}\", #{convert_currency(row[3])}, #{convert_currency(row[4])},
			#{convert_currency(row[5])}, #{convert_currency(row[6])}, #{convert_currency(row[7])}, #{convert_currency(row[8])}, #{convert_currency(row[9])},
			#{convert_currency(row[10])}, \"#{scrub_text(row[11])}\");"
		db.execute sql
		id_count += 1
	end
	puts "Done"
	db.commit

rescue SQLite3::Exception => e
	puts Exception occurred
	puts e
	db.rollback
	
ensure
	db.close if db

end