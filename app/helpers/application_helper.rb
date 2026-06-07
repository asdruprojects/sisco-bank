module ApplicationHelper
  ERROR_LABELS = {
    /document_type/ => "El tipo de documento",
    /document_number/ => "El número de documento",
    /issued_at/ => "La fecha de emisión",
    /expires_at/ => "La fecha de vencimiento",
    /full_name/ => "El nombre completo",
    /company_name/ => "La razón social",
    /email/ => "El correo electrónico",
    /phone_primary/ => "El teléfono principal",
    /phone_secondary/ => "El teléfono secundario",
    /person_type/ => "El tipo de persona"
  }.freeze

  def client_error_messages(client)
    client.errors.map { |error| friendly_client_error(error) }.uniq
  end

  def friendly_client_error(error)
    return error.message if error.attribute == :base

    label = ERROR_LABELS.find { |pattern, _| error.attribute.to_s.match?(pattern) }&.last
    return error.full_message unless label

    "#{label} #{error.message}"
  end

  def clients_filter_params
    params.permit(:name, :document, :person_type).to_h
  end

  def clients_path_with_page(page)
    clients_path(clients_filter_params.merge(page: page))
  end

  def pagination_range(pagination)
    from = ((pagination[:page] - 1) * pagination[:per_page]) + 1
    to = [ pagination[:page] * pagination[:per_page], pagination[:total_count] ].min
    { from: from, to: to }
  end
end
