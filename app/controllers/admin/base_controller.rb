class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :admin_only

  def home
  end

  def refresh_assembly_members
    AssemblyMember.refresh!
    redirect_to admin_home_path
  end

  private

  def admin_only
    #redirect_to root_path if !user_signed_in? or !current_user.has_role?(:admin)
  end
end
