class PersonalitysInsightsController < ApplicationController
  def new; end

  def create
    if params[:text].blank?
      flash.now[:alert] = "Some errors occured"
    else
      @response = PersonalityInsights.call_api(params[:text])
      @big5 = @response['personality'].select do |hash|
        hash['trait_id'] == 'big5_conscientiousness' ? { name: hash['name'], percentile: hash['percentile'] } : nil
      end
      @big5.compact!
      @warnings = @response['warnings'].map { |_, value| value }
    end
    return render :new
  end
end
