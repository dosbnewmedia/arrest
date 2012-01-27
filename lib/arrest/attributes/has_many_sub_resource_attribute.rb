module Arrest
  class HasManySubResourceAttribute < HasManyAttribute
    def initialize(ids_field_name,
                   method_name,
                   clazz_name,
                   url_part,
                   foreign_key)
      # the read_only is set to sub_resource to avoid sending post request as ids array
      # directly instead of sending the ids to the sub_resource
      super(ids_field_name, method_name, clazz_name, url_part, foreign_key, true)
    end

    def sub_resource_field_name
      @name
    end
  end
end