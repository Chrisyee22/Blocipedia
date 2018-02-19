class WikisController < ApplicationController
  before_action :authenticate_user!

  def index
   @wikis = Wiki.all

 end

 def show
   @wiki = Wiki.find(params[:id])
   unless (@wiki.private == false) || current_user.premium? || current_user.admin?
       flash[:alert] = "You must be a premium user to view private wikis."
  authorize @wiki

       if current_user
         redirect_to new_charge_path
       else
         redirect_to new_user_registration_path
       end
     end
 end

 def new
   @wiki = Wiki.new
   authorize @wiki
 end

 def create
   @wiki = Wiki.new(wiki_params)
   @wiki.user = current_user
   authorize @wiki

   if @wiki.save
     flash[:notice] = "Wiki was saved."
     redirect_to @wiki
   else
     flash.now[:alert] = "There was an error saving the wiki. Please try again."
     render :new
   end
 end

 def edit
   @wiki = Wiki.find(params[:id])
   @wiki.user = current_user
   authorize @wiki
 end

 def update
   @wiki = Wiki.find(params[:id])
   @wiki.assign_attributes(wiki_params)
   @wiki.user = current_user
   authorize @wiki
   if @wiki.save
     flash[:notice] = "Wiki was updated."
     redirect_to @wiki
   else
     flash.now[:alert] = "There was an error saving the wiki. Please try again."
     render :edit
   end
 end

 def destroy
   @wiki = Wiki.find(params[:id])
   authorize @wiki

   if @wiki.destroy
     flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
     redirect_to wikis_path
   else
     flash.now[:alert] = "There was an error deleting the wiki."
     render :show
   end
 end

 private
 def wiki_params
   params.require(:wiki).permit(:title, :body, :private)
 end
end
