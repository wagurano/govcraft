class ArchivesController < ApplicationController
  load_and_authorize_resource

  def index
    @archives = Archive.all
  end

  def create
    @archive.user = current_user
    if @archive.save
      redirect_to @archive
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @archive.update(archive_params)
      redirect_to @archive
    else
      render 'edit'
    end
  end

  def destroy
    @archive.destroy
    redirect_to archives_path
  end

  private

  def archive_params
    params.require(:archive).permit(:title, :body, :image)
  end
end