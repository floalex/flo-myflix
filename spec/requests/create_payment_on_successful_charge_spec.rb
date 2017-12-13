require 'rails_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_1BXvhgBTaoFOGB2wC9aLOzeB",
      "object" => "event",
      "api_version" => "2015-04-07",
      "created" => 1513015716,
      "data" => {
        "object" => {
          "id" => "ch_1BXvhgBTaoFOGB2w0QSYRUth",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_1BXvhgBTaoFOGB2wTnH9r45v",
          "captured" => true,
          "created" => 1513015716,
          "currency" => "usd",
          "customer" => "cus_BvnII8jHKeS2sS",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_1BXvhgBTaoFOGB2wV4QiwP9s",
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1BXvhgBTaoFOGB2w0QSYRUth/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1BXvhfBTaoFOGB2wSmX6Kj8T",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_BvnII8jHKeS2sS",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2021,
            "fingerprint" => "teVpA6cWfbB9pQS2",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "succeeded",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_uCns7YNUkwzfh7",
      "type" => "charge.succeeded"
    }
  end
  
  it 'creates a payment with the webhook from stripe for charge succeeded', :vcr do
    post '/stripe_events', event_data
    # Can't get the test passed after adding StripeEvent.signing_secret in stripe.rb
    expect(Payment.count).to eq(1)
  end
  
  it 'creates a payment associated with a user', :vcr do
    alice = Fabricate(:user, stripe_customer_token: "cus_BvnII8jHKeS2sS")
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(alice)
  end
  
  it 'creates a payment with the amount', :vcr do
    alice = Fabricate(:user, stripe_customer_token: "cus_BvnII8jHKeS2sS")
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end
  
  it 'creates a payment with a reference id', :vcr do
    alice = Fabricate(:user, stripe_customer_token: "cus_BvnII8jHKeS2sS")
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_1BXvhgBTaoFOGB2w0QSYRUth")
  end
  
end