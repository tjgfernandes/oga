module Oga
  module XML
    ##
    #
    class Comment < Text
      def to_xml
        return "<!--#{text}-->"
      end
    end # Comment
  end # XML
end # Oga