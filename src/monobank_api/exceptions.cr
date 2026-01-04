module MonobankApi
  # Base exception class for all MonobankApi errors
  class Error < Exception
  end

  # Raised when the API token is invalid or missing
  class InvalidTokenError < Error
  end

  # Raised when rate limit is exceeded (too many requests)
  class RateLimitError < Error
  end

  # Raised when the requested resource is not found
  class NotFoundError < Error
  end

  # Raised when the request parameters are invalid
  class BadRequestError < Error
  end

  # Raised when the API returns an internal server error
  class ServerError < Error
  end

  # Raised when the API is temporarily unavailable
  class ServiceUnavailableError < Error
  end
end
