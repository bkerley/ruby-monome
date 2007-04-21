module Monome
  class Font
    class << self
      def data(font_data, font_options = {})
        @font_data    = font_data.gsub(/\s+/, "").unpack("m")[0]
        @font_options = default_font_options.merge(font_options)
        
        raise ArgumentError, "must specify :width and :height" unless 
          @font_options[:width] && @font_options[:height]
        
        extract_characters_from_font_data
      end
      
      def [](char)
        @chars[char] || @chars[:blank]
      end
      
      def width
        font_options[:width]
      end
      
      def height
        font_options[:height]
      end
      
      protected
        attr_reader :font_data, :font_options
        
        def default_font_options
          { :range => 0..255, :capitalize => false }
        end

        def bits_per_char
          font_options[:bits_per_char] || width * height
        end
        
        def bytes_per_char
          ((width * height) / 8.0).ceil
        end
        
        def extract_characters_from_font_data
          @chars = {
            :blank  => Sprite.blank(width, height),
            :spacer => Sprite.blank(1, height)
          }
          
          font_options[:range].each do |char|
            @chars[char] = Sprite.new(width, *char_value(char))
            if font_options[:capitalize] && (?A..?Z).include?(char)
              @chars[char.chr.downcase[0]] = @chars[char]
            end
          end
        end
        
        def char_value(char)
          source_pos = (char - font_options[:range].first) * bytes_per_char
          bit_offset = (bytes_per_char * 8) - bits_per_char
          data = font_data[source_pos, bytes_per_char] || ("\0" * bytes_per_char)
          
          data.unpack("b*")[0].split(//).map { |i| i.to_i }[bit_offset..-1]
        end
    end
  end
end
