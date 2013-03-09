class LighthouseProjectUser < ActiveRecord::Base
  
  belongs_to :lighthouse_project
  belongs_to :lighthouse_user
end
