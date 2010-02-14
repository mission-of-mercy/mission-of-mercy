# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mission_of_mercy_session',
  :secret      => 'c8679316871c20c7b6538f7821b5f7a1d9e49d614a00076eda5ad3179a00661b37f2121e74254374357a09d59b73db910f00f326ed272d9e2ee737274f083c6a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
