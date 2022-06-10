import Foundation

enum APIError: Error {
    
    // Status 400
    case forbidden
    
    // Status code 403
    case unauthorized
    
    // Status code 404
    case notFound
    
    // Status code 422
    case validationError
    
    // Status code 500
    case internalServerError
}
