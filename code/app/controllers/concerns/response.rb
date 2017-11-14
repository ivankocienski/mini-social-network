module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def serialize_resource(thing)
    ActiveModelSerializers::SerializableResource.new thing
  end

end

