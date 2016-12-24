class PeopleController < ApplicationController
  load_and_authorize_resource

  def create
    @person.user = current_user
    if @person.save
      redirect_to people_path
    else
      errors_to_flash(@person)
      render 'new'
    end
  end

  def update
    if @person.update_attributes(person_params)
      redirect_to people_path
    else
      errors_to_flash(@person)
      render 'edit'
    end
  end

  def destroy
    unless @person.destroy
      errors_to_flash(@person)
    end
    redirect_to people_path
  end

  def search
    render json: Person.where('name like ?', "%#{params[:q]}%").map { |person| {id: person.id, text: person.name, image_url: person.image.xs.url} }
  end

  private

  def person_params
    params.require(:person).permit(:name, :body, :image)
  end
end
