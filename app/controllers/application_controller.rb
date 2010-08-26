# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
#  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  self.allow_forgery_protection = false
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # verifies that the incoming request is from an app with a valid api key
  def verify_api_key
  
  	api_key = params[:api_key]
  	app_id = params[:app_id]
	app = App.find(app_id)
	accept = false; # intially block any request
	if !app.nil? && (app.api_key == api_key) then # this is a valid request, accept it
		accept = true;
	end
	
	if !accept then 
	
		respond_to do |format|
  			format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
  					{ :request_id => params[:request_id], :result_code => "failure", :error => "Invalid API key.", :object => nil }
  				}
  			}
        end
        
  	end
 
  end
  
end
