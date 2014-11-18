module Dictionary
  module Access
    module ClassMethods

      def signature(username)
        Digest::SHA1.hexdigest( "#{username}#{Query[:salt]}" ).first(6)
      end

      def salt
        Rails.application.secrets.secret_key_base
      end

    end   
  end
end
