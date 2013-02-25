Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '393d40ccd3c63f7acb7f', 'cfb9e9892e223514652b1f0302a605740f49cc17'
end