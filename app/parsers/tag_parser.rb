class TagParser < ActsAsTaggableOn::GenericParser
  def parse
    ActsAsTaggableOn::TagList.new.tap do |tag_list|
      tag_words = @tag_list.split(/[,\s]+/)
      new_tag_list = tag_words.map { |w| w.first == '#' ? w[1..-1] : w }
      tag_list.add new_tag_list
    end
  end
end
