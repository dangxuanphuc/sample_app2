module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if  cookies.encrypted["_sample_app2_session"].present? && 
        cookies.encrypted["_sample_app2_session"]["user_id"]
          User.find_by(id: cookies.encrypted["_sample_app2_session"]["user_id"])
      else
        reject_unauthorized_connection
      end
    end
  end
end
