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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_amazon_credential
      @amazon_credential = AmazonCredential.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def amazon_credential_params
      params.expect(amazon_credential: [ :access_token, :string, :refresh_token, :string ])
    end
end
