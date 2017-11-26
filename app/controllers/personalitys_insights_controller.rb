class PersonalitysInsightsController < ApplicationController
  def new; end

  def create
    if params[:text].blank?
      flash.now[:alert] = "Some errors occured"
    else
      @response = PersonalityInsights.call_api(params[:text])
      build_big5_plot(@response['personality'])
      @warnings = @response['warnings'].map { |_, value| value }
    end
    return render :new
  end

  private

  def build_big5_plot(response)
    genre =[]
    aData =[]
    response.each do |hash|
      next unless hash['trait_id'] =~ /\Abig5_/
      genre << hash['name']
      aData << hash['percentile']
    end
    byebug
    return if [genre, aData].any?(&:empty?)
    @big5_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(polar: true,type:'line')
      f.pane(size:'80%')
      f.title(text: 'ビッグ5情報')
      f.xAxis(categories: genre,tickmarkPlacement:'on')
      f.yAxis(gridLineInterpolation: 'polygon',lineWidth:0,min:0,max:1) 
      f.series(name:'',data: aData,pointPlacement:'on')
      f.legend(align: 'right', verticalAlign: 'top', y: 70, layout: 'vertical')
    end
  end
end
