class ClientsController < ApplicationController
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    clients = Client.active.recent
    clients = clients.search_by_name(params[:name])         if params[:name].present?
    clients = clients.search_by_document(params[:document]) if params[:document].present?
    clients = clients.by_person_type(params[:person_type])  if params[:person_type].present?
    @clients = paginate(clients)
  end

  def show; end

  def new
    @client = Client.new
    @client.build_natural_person
    @client.build_legal_entity
    @client.documents.build
  end

  def create
    @client = Client.new(create_params)
    if @client.save
      redirect_to @client, notice: "Cliente creado exitosamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @client.person_type == "natural"
      @client.build_natural_person if @client.natural_person.nil?
    else
      @client.build_legal_entity if @client.legal_entity.nil?
    end
    @client.documents.build if @client.documents.empty?
  end

  def update
    if @client.update(update_params)
      redirect_to @client, notice: "Cliente actualizado exitosamente"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.soft_delete
    redirect_to clients_path, notice: "Cliente eliminado exitosamente"
  end

  private

  def set_client
    @client = Client.active.find(params[:id])
  end

  def create_params
    params.require(:client).permit(
      :person_type, :email, :phone_primary, :phone_secondary,
      documents_attributes: [ :id, :document_type, :document_number, :issued_at, :expires_at ],
      natural_person_attributes: [ :id, :full_name ],
      legal_entity_attributes: [ :id, :company_name ],
    )
  end

  def update_params
    params.require(:client).permit(
      :email, :phone_primary, :phone_secondary,
      documents_attributes: [ :id, :document_type, :document_number, :issued_at, :expires_at ],
      natural_person_attributes: [ :id, :full_name ],
      legal_entity_attributes: [ :id, :company_name ],
    )
  end
end
