module Quiin

  class Server < Sinatra::Base
    helpers do
      def readable_datetime(datetime) 
        datetime.strftime("%Y-%m-%d %H:%M:%S")
      end
    end
  end

end