require 'rails_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_1BY2wyBTaoFOGB2w9NY3JRZg",
      "object" => "event",
      "api_version" => "2015-04-07",
      "created" => 1513043572,
      "data" => {
        "object" => {
          "id" => "ch_1BY2wxBTaoFOGB2wCBkeNCj5",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1513043571,
          "currency" => "usd",
          "customer" => "cus_BvsangXNChy0HL",
          "description" => "fail payment",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {
          },
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1BY2wxBTaoFOGB2wCBkeNCj5/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1BY2w2BTaoFOGB2wM6F0LuzY",
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
            "customer" => "cus_BvsangXNChy0HL",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2024,
            "fingerprint" => "FuZgkYUxELg9CrzU",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 2,
      "request" => "req_MCUcdFJPwXPD7T",
      "type" => "charge.failed"
    }
  end
  
  it 'deactivates user with event data from stripe webhook on failed charge', :vcr do
    alice = Fabricate(:user, email: 'alice@example.com', stripe_customer_token: "cus_BvsangXNChy0HL")
    post '/stripe_events', event_data
    expect(alice.reload).not_to be_active
  end
end