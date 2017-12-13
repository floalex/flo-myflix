CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    # config.storage = :aws
    # config.aws_bucket = 'S3_BUCKET_NAME'
    # config.aws_acl    = 'public-read'

    # # The maximum period for authenticated_urls is only 7 days.
    # config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
    
    # config.aws_credentials = {
    #   provider:              'AWS',                        # required
    #   aws_access_key_id:     'xxx',                        # required
    #   aws_secret_access_key: 'yyy',                        # required
    #   region:                'eu-west-1',                  # required
    # }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end