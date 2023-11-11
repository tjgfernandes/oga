module Oga
  module XML
    # Module that provides:
    # a `#to_xml` method that serialises the current node
    # a `#children_to_xml` method that serialises the children of the current node
    # back to XML.
    module ToXML
      # @return [String]
      def to_xml
        Generator.new(self).to_xml
      end

      # @return [String]
      def children_to_xml
        Generator.new(self).children_to_xml
      end

      alias_method :to_s, :to_xml
    end
  end
end
