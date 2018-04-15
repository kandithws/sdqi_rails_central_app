require 'net/http'
require 'uri'

module MyOmise
  # Light weight and naive implementation to generate tesco lotus bill using Omise

  # create identifier for our bill
  def create_bill_source amount
    url = 'https://%s:@api.omise.co/sources' % [ ENV['OMISE_SECRET_KEY'] ]
    puts '-----------------------HELLO WORLDDD----------------------------'
    puts url
    api_uri = URI.parse(url)
    # must convert amout to satang
    data = {'amount' => (amount * 100).to_i.to_s, 'currency' => 'thb', 'type' => 'bill_payment_tesco_lotus'}
    puts data
    res = Net::HTTP.post_form(api_uri, data)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      puts res.body
      JSON.parse(res.body)
    else
      puts res.body
      puts res.error!
      nil
    end
  end

  # create a bar code that will be expired within 24 hours
  def charge_bill_source bill_src_id, bill_id, amount
    url = 'https://%s:@api.omise.co/charges' % [ ENV['OMISE_SECRET_KEY'] ]
    api_uri = URI.parse(url)
    # must convert amout to satang
    data = {'amount' => (amount * 100).to_i.to_s, 'currency' => 'thb', 'source' => bill_src_id.to_s,
            'description' => 'Charge for bill id ' + bill_id.to_s}
    puts data
    res = Net::HTTP.post_form(api_uri, data)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      puts res.body
      JSON.parse res.body
    else
      puts res.body
      puts res.error!

      nil
    end
  end
end