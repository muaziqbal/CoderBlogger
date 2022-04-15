class JobSubscriptionsController < ApplicationController
  def new
    @subscription = JobSubscription.new
  end

  def create
    @subscription = JobSubscription.new(subscription_params)
    if !@subscription.save
      render action: 'new'
      return
    end

    @subscription.charge!(params['stripeToken'])

    flash[:notice] = "Your subscription has started"
    redirect_to jobs_path

  rescue Stripe::CardError => e
    flash[:notice] = e.message
    redirect_to new_job_subscription_path(@subscription)
  end

  # private

  def subscription_params
    params.require(:job_subscription).permit(
      :jobs_url,
      :company_name,
      :contact_email,
      :stripe_customer_id,
    )
  end

end
