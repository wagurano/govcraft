if !Rails.env.production?

  LetterOpener.configure do |config|
    # To render only the message body, without any metadata or extra containers or styling.
    # Default value is <tt>:default</tt> that renders styled message with showing useful metadata.
    # config.message_template = :light
  end

end
