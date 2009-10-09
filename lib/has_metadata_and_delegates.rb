module HasMetadataAndDelegates
  def has_metadata_and_delegates(*args)
    define_method :metadata_with_creation do
      self.metadata_without_creation || self.create_metadata
    end
    alias_method_chain :metadata, :creation

    before_save do |record|
      record.metadata.save if record.metadata_without_creation
    end
    
    delegations = args.collect { |a| a.to_s.match(/(.*)\*/) ? [$1.to_sym, :"#{$1}?", :"#{$1}="] : a }.flatten
    delegations << {:to => :metadata}
    
    delegate *delegations
    
  end
end