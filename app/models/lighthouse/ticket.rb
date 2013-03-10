class Lighthouse::Ticket < OpenStruct

  def to_attributes
    {
      assigned_lighthouse_id: assigned_user_id,
      body:                   original_body_html,
      lighthouse_id:          creator_id,
      number:                 number,
      service:                'lh',
      ticket_created_at:      created_at,
      ticket_updated_at:      updated_at,
      title:                  title,
      url:                    url
    }
  end
end