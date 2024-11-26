AMAZON_OAuth_CONFIG = {
  client_id: ENV["AMAZON_CLIENT_ID"],
  client_secret: ENV["AMAZON_CLIENT_SECRET"],
  redirect_uri: "http://localhost:3000/amazon_credentials/callback",
  authorization_url: "https://sellercentral.amazon.com/apps/authorize/consent",
  token_url: "https://api.amazon.com/auth/o2/token"
}
