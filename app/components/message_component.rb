# frozen_string_literal: true

class MessageComponent < ViewComponent::Base
  def initialize(notice: nil, alert: nil, errors: nil)
    @notice = notice
    @alert = alert
    @errors = errors
  end
end
