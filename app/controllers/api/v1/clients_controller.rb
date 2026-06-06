module Api
  module V1
    class ClientsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_client, only: [ :show, :update, :destroy ]

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def index
        clients = Client.active.recent
        clients = clients.search_by_name(params[:name])         if params[:name].present?
        clients = clients.search_by_document(params[:document]) if params[:document].present?
        clients = clients.by_person_type(params[:person_type])  if params[:person_type].present?
        render json: clients.map(&:as_api_json)
      end

      def show
        render json: @client.as_api_json
      end

      def create
        client = Client.new(client_params)
        if client.save
          render json: client.as_api_json, status: :created
        else
          render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @client.update(client_params)
          render json: @client.as_api_json
        else
          render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @client.soft_delete
        render json: { message: "Cliente eliminado exitosamente" }
      end

      private

      def set_client
        @client = Client.active.find(params[:id])
      end

      def not_found
        render json: { error: "Cliente no encontrado" }, status: :not_found
      end

      def client_params
        params.require(:client).permit(
          :person_type, :email, :phone_primary, :phone_secondary,
          documents_attributes: [ :id, :document_type, :document_number, :issued_at, :expires_at ],
          natural_person_attributes: [ :id, :full_name ],
          legal_entity_attributes: [ :id, :company_name ],
        )
      end
    end
  end
end
