# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Gaming@Stanford_session',
  :secret      => 'e4db13fe20e0561ece2c7c36054f021da4a7f3d76dc8a9e9d367a6ed7512bf3d58a53ca9756d9f2c99e9e69847efc87298543045ec69722d11ac5d3e2c463543'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
