class RootController < ApplicationController

  include Response

  def root
    payload = {
      title: 'Mini Social Network',
      description: 'A small JSON API for communicating amongst users',
      api_version: 'V1'
    }
    json_response payload
  end
end
