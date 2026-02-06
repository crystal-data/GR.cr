module GRCommon
  # Custom exception classes for GR library errors

  # Base exception for all GR-related errors
  class GRError < Exception
  end

  # Raised when invalid data is passed to a GR function
  class InvalidDataError < GRError
  end

  # Raised when array dimensions don't match
  class DimensionMismatchError < GRError
  end

  # Raised when required data is missing
  class MissingDataError < GRError
  end

  # Raised when GR library is not properly initialized
  class NotInitializedError < GRError
  end

  # Raised when memory allocation fails
  class MemoryError < GRError
  end

  # Raised when an unsupported operation is attempted
  class UnsupportedOperationError < GRError
  end
end
