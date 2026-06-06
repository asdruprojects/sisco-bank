puts "Creando clientes naturales..."

[
  { name: "José García",     email: "jose.garcia@gmail.com",   phone: "04141234567", doc_type: "cedula",    doc_num: "V-12345678" },
  { name: "María Rodríguez", email: "maria.rod@gmail.com",     phone: "04241234567", doc_type: "cedula",    doc_num: "V-87654321" },
  { name: "Carlos Pérez",    email: "carlos.perez@gmail.com",  phone: "04121234567", doc_type: "pasaporte", doc_num: "AB123456"   },
  { name: "Ana Martínez",    email: "ana.martinez@gmail.com",  phone: "04161234567", doc_type: "cedula",    doc_num: "V-11223344" },
  { name: "Luis González",   email: "luis.gonzalez@gmail.com", phone: "04261234567", doc_type: "pasaporte", doc_num: "CD789012"   }
].each do |data|
  client = Client.find_or_create_by(email: data[:email]) do |c|
    c.person_type   = "natural"
    c.phone_primary = data[:phone]
  end

  NaturalPerson.find_or_create_by(client: client) do |np|
    np.full_name = data[:name]
  end

  Document.find_or_create_by(document_type: data[:doc_type], document_number: data[:doc_num]) do |d|
    d.client    = client
    d.issued_at = Date.new(2020, 1, 1)
    d.expires_at = Date.new(2030, 1, 1)
  end
end

puts "Creando clientes jurídicos..."

[
  { name: "Inversiones ABC C.A.",     email: "info@abc.com",     phone: "02121234567", doc_num: "J-123456780" },
  { name: "Servicios XYZ S.R.L.",     email: "info@xyz.com",     phone: "02124567890", doc_num: "J-987654320" },
  { name: "Constructora Delta C.A.",  email: "info@delta.com",   phone: "02125678901", doc_num: "J-112233440" },
  { name: "Tech Solutions Venezuela", email: "info@techsol.com", phone: "02126789012", doc_num: "J-445566770" }
].each do |data|
  client = Client.find_or_create_by(email: data[:email]) do |c|
    c.person_type   = "juridico"
    c.phone_primary = data[:phone]
  end

  LegalEntity.find_or_create_by(client: client) do |le|
    le.company_name = data[:name]
  end

  Document.find_or_create_by(document_type: "rif", document_number: data[:doc_num]) do |d|
    d.client     = client
    d.issued_at  = Date.new(2019, 6, 1)
    d.expires_at = Date.new(2029, 6, 1)
  end
end

puts "✅ Seeds completados: #{Client.count} clientes en total"
