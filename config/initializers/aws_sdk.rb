# frozen_string_literal: true

require 'aws-sdk-ses'

aws_credentials = Rails.application.credentials[:aws]
access_key_id = aws_credentials[:access_key_id] if aws_credentials.present?
secret_access_key = aws_credentials[:secret_access_key] if aws_credentials.present?

Aws.config.update({
                    region: 'eu-central-1',
                    credentials: Aws::Credentials.new(access_key_id, secret_access_key)
                  })
