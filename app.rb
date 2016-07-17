require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'json'
require 'rest_client'

set :bind, '0.0.0.0'
set :port, 4567

Choices = {
  'avg' => 'average',
  'min' => 'minimum',
  'max' => 'maximum'
}

begin
	get '/' do
		erb :index, :layout => :layout
	end

	post '/result' do
		response = RestClient.post 'http://0.0.0.0:4567/salary', {:title => params[:title], :stat => params[:stat]}, {:content_type => :json, :accept => :json}
    	result = JSON.parse(response, :symbolize_names => true)
    	erb :result, :layout => :layout, :locals => {:result => result}
	end

	def is_sql_injection(text)
		# quick check for basic sql injection
		sql_terms = ['from', 'select', 'where', 'delete', 'group by', 'order by', ';']
		sql_terms.each do |term|
			return true if text.split().include?(term)
		end
		return false
	end

	post '/salary' do
		result = {
			:title => params[:title].downcase || '',
			:stat => params[:stat] || 'avg',
			:success => false,
			:message => ''}
		if result[:title].to_s == ''
			result[:message] = "No title specified"
			result.to_json
		else
			if is_sql_injection(result[:title]) || is_sql_injection(result[:stat])
				result[:message] = 'SQL injection-like query flagged and rejected.'
			elsif not Choices.keys.include? result[:stat]
				result[:message] = 'Please enter either: avg, min, or max. API defaults to avg'
			else
				db = SQLite3::Database.open 'ingestion/data/beer.db'
				sql = "SELECT #{result[:stat]}(total_earnings)
				 		FROM employee_earnings
				 		WHERE title LIKE \'%#{result[:title]}%\';"
				income_result = db.execute sql
				if income_result[0][0].nil?
					result[:message] = "No results returned for #{result[:title]}."
				else
					result[:income_result] = '%.2f' % income_result[0][0]
				end
				result[:success] = true
			end
			puts result
			result.to_json
		end
	end

	# 404 page
	not_found do
  		halt 404, 'page not found'
	end

end