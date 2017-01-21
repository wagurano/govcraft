class Admin::RolesController < Admin::BaseController
  def add
    user = User.find_by! nickname: params[:user_nickname]
    user.add_role(:admin)
    user.save!
    redirect_to admin_roles_path
  end

  def remove
    user = User.find_by! nickname: params[:user_nickname]
    user.remove_role(:admin)
    user.save!
    redirect_to admin_roles_path
  end
end
