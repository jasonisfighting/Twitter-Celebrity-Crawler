require 'open-uri'
require 'twitter'
name = [] 
ur = "http://en.wikipedia.org/wiki/List_of_American_film_actresses"
path = "/Users/xxxx/Desktop/celebrity1"
client = Twitter::REST::Client.new  do |config|
	config.consumer_key = "4tzYozOUTabzw4ElqO4lGQ"
	config.consumer_secret = "iuTXrtKpEFE9fsa9X1vyMq4lMfxFb3hcbCiQz9kVuN0"
	config.access_token = "1873023186-uvLz1BoeE3gF2MUMNGrcSXGFPNqSMcBYnuUo0tZ"
	config.access_token_secret = "J0ZWMgSFTq53G2K3NKRGz4EMIM7qAQzmTyfkWU9HoXFvs"
end
	outFile = File.new(path,"w")
	outFile.puts("ACTRESS|TWITTER URL")
	web_content = open(ur).read
	pattern = /">(.*)<\/a>.*19/
	puts web_content.scan(pattern).class
	web_content.scan(pattern) do |match|
	MAX_ATTEMPTS = 3
	num_attempts = 0
	begin
		num_attempts += 1
		@twitter = client.user_search(match.join(","))
    	if @twitter
	    	if twitter_user = @twitter.first
		    	puts "#{twitter_user[:name]}||#{twitter_user[:url]}"
	    	    outFile.puts("#{twitter_user[:name]}|#{twitter_user[:url]}")
	    	end
    	end
    rescue Twitter::Error::TooManyRequests => error
    	if num_attempts <= MAX_ATTEMPTS
    		sleep error.rate_limit.reset_in
    		retry
    	else
    		raise
    	end
    end
end
puts "finish inserting"
outFile.close if outFile
