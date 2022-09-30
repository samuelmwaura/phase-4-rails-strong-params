class BirdsController < ApplicationController

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    #bird = Bird.create(name: params[:name], species: params[:species])
    #This way of creating resources would soon be rediculous when the attributes are more.We then need use a better way of passing a hash diretly since it is what the create actions expects.
    #We cannot just pass params in the create action since it would mean a security breach such that any key/value pair sent is executed.
    #Passing in params directly in the create action causes an activeRecord::ForbiddenAttributeError
    #The vulnerability is called mass assignment vulnerability i.e user can update any other attribute apart from name and species since they can pass it in the params.
    #This problem is sorted by using the strong params where only the permitted pearams will be used to create a new record in the database.

    bird = Bird.create(bird_params)  #Bird_params is an invoked method.
    #A new hash is created with only the permitted attribute and which will be the only one used to create a resource.
    #When a post is made with more attributes in the params, only the params that are permitted will be used to create a new resource in the database.
    #Inorder to promote DRYness of code, it is a good practice to export the peram permitting functionality to a new private method.
    render json: bird, status: :created
  end

  # GET /birds/:id
  def show
    bird = Bird.find_by(id: params[:id])
    if bird
      render json: bird
    else
      render json: { error: "Bird not found" }, status: :not_found
    end
  end

  private

  def bird_params
    params.permit(:name, :species)
  end
  #This method will be used for the create and udate thus promoting code Dryness.

end
