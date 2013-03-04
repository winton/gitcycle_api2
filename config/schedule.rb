every 1.minute do
  runner "Lighthouse::Ticket.delay(retry: false, timeout: 60).update!"
end