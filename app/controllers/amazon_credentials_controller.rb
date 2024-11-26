class AmazonCredentialsController < ApplicationController
  before_action :set_amazon_credential, only: %i[ show edit update destroy ]

  # GET /amazon_credentials or /amazon_credentials.json
  def index
    @amazon_credentials = AmazonCredential.all
  end

  # GET /amazon_credentials/1 or /amazon_credentials/1.json
  def show
  end

  # GET /amazon_credentials/new
  def new
    @amazon_credential = AmazonCredential.new
  end

  # GET /amazon_credentials/1/edit
  def edit
  end

  # POST /amazon_credentials or /amazon_credentials.json
  def create
    @amazon_credential = AmazonCredential.new(amazon_credential_params)

    respond_to do |format|
      if @amazon_credential.save
        format.html { redirect_to @amazon_credential, notice: "Amazon credential was successfully created." }
        format.json { render :show, status: :created, location: @amazon_credential }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @amazon_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amazon_credentials/1 or /amazon_credentials/1.json
  def update
    respond_to do |format|
      if @amazon_credential.update(amazon_credential_params)
        format.html { redirect_to @amazon_credential, notice: "Amazon credential was successfully updated." }
        format.json { render :show, status: :ok, location: @amazon_credential }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @amazon_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amazon_credentials/1 or /amazon_credentials/1.json
  def destroy
    @amazon_credential.destroy!

    respond_to do |format|
      format.html { redirect_to amazon_credentials_path, status: :see_other, notice: "Amazon credential was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def login
    state = SecureRandom.hex(16)
    session[:amazon_oauth_state] = state

    auth_params = {
      application_id: AMAZON_OAuth_CONFIG[:client_id],
      state: state,
      redirect_uri: AMAZON_OAuth_CONFIG[:redirect_uri],
      version: "beta"
    }

    redirect_to "#{AMAZON_OAuth_CONFIG[:authorization_url]}?#{auth_params.to_query}", allow_other_host: true
  end

  def callback
    # Verify state to prevent CSRF
    unless params[:state] == session[:amazon_oauth_state]
      redirect_to amazon_credentials_path, alert: "Invalid state parameter"
      return
    end

    # Exchange the authorization code for tokens
    response = HTTP.post(AMAZON_OAuth_CONFIG[:token_url], form: {
      grant_type: "authorization_code",
      code: params[:spapi_oauth_code],
      client_id: AMAZON_OAuth_CONFIG[:client_id],
      client_secret: AMAZON_OAuth_CONFIG[:client_secret],
      redirect_uri: AMAZON_OAuth_CONFIG[:redirect_uri]
    })

    if response.status.success?
      token_data = JSON.parse(response.body.to_s)

      # Save the credentials
      @amazon_credential = AmazonCredential.new(
        access_token: token_data["access_token"],
        refresh_token: token_data["refresh_token"]
      )

      if @amazon_credential.save
        setup_peddler_client(@amazon_credential)
        redirect_to amazon_credentials_path, notice: "Successfully connected to Amazon"
      else
        redirect_to amazon_credentials_path, alert: "Failed to save credentials"
      end
    else
      redirect_to amazon_credentials_path, alert: "Failed to obtain Amazon credentials"
    end
  end


  private

  def setup_peddler_client(credential)
    # Initialize Peddler client with the credentials
    client = MWS.orders(
      marketplace: "ATVPDKIKX0DER", # US marketplace ID
      merchant_id: ENV["AMAZON_SELLER_ID"],
      auth_token: credential.access_token
    )

    # You can store the client in a class variable or handle it as needed
    @mws_client = client
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_amazon_credential
      @amazon_credential = AmazonCredential.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def amazon_credential_params
      params.expect(amazon_credential: [ :access_token, :string, :refresh_token, :string ])
    end
end
