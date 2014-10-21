module Analytical
  module Modules
    class GoogleUniversal
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        domain = options[:domain] ? "{'cookieDomain': '#{options[:domain]}'}" : "'auto'"
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Google Universal -->
          <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

            ga('create', '#{options[:key]}', #{domain});
            ga('require', 'displayfeatures');
            ga('send', 'pageview');

          </script>
          HTML
          js
        end
      end

      def event(name, *args)
        data = args.first || {}
        data = data[:value] if data.is_a?(Hash)
        ga 'send', 'event', 'Event', name, data.to_s
      end

      def custom_event(category, action, opt_label=nil, opt_value=nil)
        ga 'send', 'event', category, action, opt_label, opt_value
      end

      def identify(id, *args)
        ga 'set', '&uid', id
      end

      private

      def ga(*array)
        args = array.reject(&:blank?).join("', '")
        "ga('#{args}');"
      end
    end
  end
end
