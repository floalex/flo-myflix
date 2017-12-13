Stripe.api_key = ENV['STRIPE_SECRET_KEY']
# StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

# Need to change the webhook url to local server as https://{url_name}/stripe_events
# can install ngrok if not in IDE development

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(stripe_customer_token: event.data.object.customer)
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by(stripe_customer_token: event.data.object.customer)
    user.deactivate!
  end
end


