class Lighthouse::Ticket < OpenStruct

  def to_attributes
    {
      body:              original_body_html,
      number:            number,
      service:           'lh',
      ticket_created_at: created_at,
      ticket_updated_at: updated_at,
      title:             title,
      url:               url
    }
  end
end