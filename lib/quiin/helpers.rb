module Quiin

  class Server < Sinatra::Base
    helpers do
      def readable_datetime(datetime) 
        datetime.strftime("%Y-%m-%d %H:%M:%S")
      end

      def type_of_run(quiin_run)
        if quiin_run.warning?
          "warning_run"
        elsif quiin_run.error? 
          "failed_run"
        else
          "successful_run"
        end
      end
    end
  end

end