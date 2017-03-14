Rails.logger.info 'Loading assembly_members...'
if !Rails.env.test? and !Rails.env.development?
  AssemblyHelper.prepare_assembly_members
end

