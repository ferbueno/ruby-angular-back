class PeopleController < ApplicationController

  def_param_group :person do
    param :person, Hash, :required => true do
      param :name, String, :desc => "Person's given name", :required => true
      param :last_name, String, :desc => "Person's family name", :required => true
      param :age, Integer, :desc => "Person's age", :required => true
    end
  end

  api :GET, "/people", "Get all people related to the tenant"
  formats ['json']
  description 'Gets all people related to the tenant.'
  def index
    @people = Person.all
    render @people
  end

  def show
    @person = Person.find params[:id]
    render @person
  end

  def create
    @person = Person.new person_params
    if @person.save
      render @person
    end
  end

  private
    def person_params
      params.require(:person).permit(:name, :last_name, :age)
    end
end
