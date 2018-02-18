class ChargesController < ApplicationController


  def new

    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership",
     amount: amount
   }
  end

  def create
    # Creates a Stripe Customer object, for associating
   # with the charge
   customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )

   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: amount,
     description: "Premium Membership",
     currency: 'usd'
   )
       current_user.stripe_id = customer.id
       current_user.role = :premium
       current_user.save!
   flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
   redirect_to root_path # or wherever

   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
      current_user.role = :standard
      current_user.wikis.each { |wiki| wiki.update_attribute(:private, false) }
      flash[:notice] = "Your premium membership has been canceled."
      redirect_to edit_user_registration_path(current_user)
  end

  private

     def amount
       15_00
     end

end
