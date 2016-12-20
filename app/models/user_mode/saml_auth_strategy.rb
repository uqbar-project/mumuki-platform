class UserMode::SamlAuthStrategy < UserMode::MultiUser
  def set_auth_provider(omniauth)
    omniauth.provider :saml,
      # TODO: change the :assertion_consumer_service_url, the :issuer and the :slo_default_relay_state:
      # =>  1. we can not call any Organization method since there is none instantiated yet and
      # =>  2. we must use the absolut path to generate the right SAML metadata to set up the federation with the IdP
      :assertion_consumer_service_url     => "http://central.#{Rails.configuration.domain}:3000/auth/saml/callback",
      :issuer                             => "http://central.#{Rails.configuration.domain}:3000/auth/saml",
      :idp_sso_target_url                 => Rails.configuration.saml_idp_sso_target_url,
      :idp_slo_target_url                 => Rails.configuration.saml_idp_slo_target_url,
      :slo_default_relay_state            => "http://central.#{Rails.configuration.domain}:3000",
      :idp_cert                           => File.read('./saml.crt'),
      :attribute_service_name             => 'Mumuki',
      :request_attributes                 => [
        { :name => 'email', :name_format => 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', :friendly_name => 'Email address' },
        { :name => 'name', :name_format => 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', :friendly_name => 'Full name' },
        { :name => 'image', :name_format => 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', :friendly_name => 'Avatar image' }
      ],
      :attribute_statements               => {
        name: ["name"],
        email: ["email"],
        image: ["image"]
      }
  end

  def protect_from_forgery(controller)
    # Do nothing (do not protect): the IdP calls the assertion_url via POST and without the CSRF token
  end

  def auth_link
    # Was using Organization.url_for('/auth/saml/') but the port got lost (is it a bug?)
    'href="http://central.' + Rails.configuration.domain + ':3000/auth/saml/"'
  end

end