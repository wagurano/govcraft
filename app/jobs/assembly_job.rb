class AssemblyJob
  include Sidekiq::Worker
  def perform
    AssemblyHelper.prepare_assembly_members
  end
end
