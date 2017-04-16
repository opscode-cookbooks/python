class Chef
  #
  # Base helpers to cleanup recipe logic.
  #
  class Recipe
    #
    # Determine if the current node using old RHEL.
    #
    # @return [Boolean]
    #
    def rhel5x?
      major_version = node['platform_version'].split('.').first.to_i
      platform_family?('rhel') && major_version < 6
    end
  end
end
