# This module contains commons methods
module APIHelpers
  def authenticate!
    token = req.env['HTTP_X_PAYE_APPLICATION-NAME_ACCESS_TOKEN']
    api_forbidden! if token.nil?

    user = User.first(access_token: token)
    api_unauthorized! unless user

    @@user_id = user.id
  end

  def current_user_id
    @@user_id
  end

  def require_permission(role)
    user = User[current_user_id]
    api_unauthorized! unless UserRole.can_access?(role, user.role)
  end

  def api_bad_request!(message = 'Bad Request')
    error! 400, message: message
  end

  def api_unauthorized!(message = 'Invalid credentials')
    error! 401, message: message
  end

  def api_forbidden!(message = 'You are not allowed to access this resource')
    error! 403, message: message
  end

  def api_not_found!(message = 'The specified resource does not exist')
    error! 404, message: message
  end

  def api_unsupported_media_type!(message = 'Unsupported Media Type')
    error! 415, message: message
  end

  def api_unprocessable!(entity, message = 'Validation Failed')
    error! 422, message: message, errors: entity.errors
  end

  def api_internal_server_error!(message = 'Internal Server Error')
    error! 500, message: message
  end

  def api_service_unavailable!(
        message = 'Service Unavailable. Try again after 60 seconds'
      )
    error! 503, message: message
  end

  def error!(status, body)
    res.status = status

    json(body)

    halt res.finish
  end

  def exception_for(symbol, exception)
    Struct.new(:errors).new(
      symbol => "#{exception.message} -> #{exception.backtrace}"
    )
  end

  def api_created!(url = nil, resource_response = nil)
    res.status = 201
    res['Location'] = url unless url.nil?
    json resource_response unless resource_response.nil?
    halt res.finish
  end

  def api_no_content!
    res.headers.delete('Content-Type')
    res.status = 204
    halt res.finish
  end

  def json(value, status = nil)
    res.status = status if status
    res.headers['Content-Type'] = 'application/json'
    res.write value.to_json
  end
end
