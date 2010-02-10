# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_openislam_session',
  :secret => '8a46d44bb7bde17f2e1f9fc477529d7870308105a2984fd02c96e6230c338986509c437dacd101d7da086b49b010c8f5f061bf6f1fda9075636f1eebd9d60558'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
