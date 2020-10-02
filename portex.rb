require 'httparty'
require 'sendgrid-ruby'
include SendGrid

# key for open exchange api
app_id = ENV['EXCHANGE_RATE_APP_ID']
url = "https://openexchangerates.org/api/latest.json?app_id=#{app_id}"

response = HTTParty.get(url)
parsed_response = JSON.parse(response.body)
rates = parsed_response["rates"]

currencies = ["AUD", "GBP", "EUR", "JPY", "CAD", "CHF", "HKD", "CNH"]

exchange_rates = ""

currencies.each {|currency| exchange_rates += "#{currency}: #{rates[currency]}\n " }

p "exchange_rates: #{exchange_rates}"

# emails = ['todd.metheny@lana.com', 'sam@portexpro.com', 'brittany@portexpro.com']
emails = ['todd.metheny@lana.com']

# send an email
emails.each do |email|
  from = Email.new(email: 'todd.metheny@gmail.com')
  to = Email.new(email: email)
  subject = 'Portex daily conversion rate email'
  content = Content.new(type: 'text/plain', value: "Great talking today! Obviously this should look pretty. This is generated from a simple ruby script that grabs many exchange rates via an api call. \n #{exchange_rates} \n\n Todd")
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
end
