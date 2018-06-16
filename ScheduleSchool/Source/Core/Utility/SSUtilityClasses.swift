//
//  SSUtilityClasses.swift
//  Schedule School
//
//  Created by Máté on 2017. 11. 11.
//  Copyright © 2017. theMatys. All rights reserved.
//

import UIKit

/// The color utility class of the application.
class SSColor
{
    // MARK: Properties
    
    /// The red component of the color (0 to 255).
    var red: Int
    {
        get
        {
            return Int(data[0])
        }
    }
    
    /// The green component of the color (0 to 255).
    var green: Int
    {
        get
        {
            return Int(data[1])
        }
    }
    
    /// The blue component of the color (0 to 255).
    var blue: Int
    {
        get
        {
            return Int(data[2])
        }
    }
    
    /// The alpha component of the color (0 to 1).
    var alpha: Float
    {
        get
        {
            return data[3]
        }
    }
    
    /// The hexadecimal representation of the color.
    var hexadecimalString: String
    {
        get
        {
            return String(red, radix: 16) + String(green, radix: 16) + String(blue, radix: 16)
        }
    }
    
    /// The `UIColor` representation of the color.
    var uiColor: UIColor
    {
        get
        {
            return UIColor(red: CGFloat(data[0] / 255), green: CGFloat(data[1] / 255), blue: CGFloat(data[2] / 255), alpha: CGFloat(data[3]))
        }
    }
    
    /// The `CGColor` representation of the color.
    var cgColor: CGColor
    {
        get
        {
            return uiColor.cgColor
        }
    }
    
    /// All the components of the color.
    private var data: [Float]
    
    // MARK: Initializers

    /// Initializes an `SSColor` instance from a hexadecimal string and an alpha value.
    ///
    /// - Parameters:
    ///   - hexadecimal: The hexadecimal string which represents the color.
    ///   - alpha: The alpha value which the color should be displayed with.
    convenience init(hexadecimal: String, alpha: Float)
    {
        self.init(hexadecimal: String(Int(alpha * 255), radix: 16))
    }
    
    /// Initializes an `SSColor` instance from a hexadecimal string.
    ///
    /// - Parameter hexadecimal: The hexadecimal string which represents the color.
    convenience init(hexadecimal: String)
    {
        // Define the array which holds each parsed hexadecimal component
        var parsedHexadecimals: [Int] = [Int]()
        
        // Define the buffer character variable. Each hexadecimal component consists of two characters, therefore we must buffer one character per component
        var bufferedCharacter: Character!
        
        // Iterate through each character in the hexadecimal string
        for character in hexadecimal
        {
            if(bufferedCharacter == nil)
            {
                // If we have just begun to parse a new component, buffer the first character
                bufferedCharacter = character
            }
            else
            {
                // If we are at the second (and last) character of the component, create the hexadecimal component
                let hexadecimalString: String = String(bufferedCharacter) + String(character)
                
                // Parse the hexadecimal component safely
                guard let parsedHexadecimal: Int = Int(hexadecimalString, radix: 16) else
                {
                    fatalError("Could not parse hexadecimal fragment \"" + hexadecimalString + "\" to integer from raw hexadecimal string \"0x" + hexadecimal + "\" in SSColor")
                }
                
                // Reset the buffered character
                bufferedCharacter = nil
                
                // Save the parsed hexadecimal component
                parsedHexadecimals.append(parsedHexadecimal)
            }
        }
        
        if(parsedHexadecimals.count >= 4)
        {
            self.init(red: parsedHexadecimals[1], green: parsedHexadecimals[2], blue: parsedHexadecimals[3], alpha: Float(parsedHexadecimals[0] / 255))
        }
        else
        {
            self.init(red: parsedHexadecimals[0], green: parsedHexadecimals[1], blue: parsedHexadecimals[2], alpha: 1.0)
        }
    }
    
    /// Initializes an `SSColor` instance from RGB components.
    ///
    /// - Parameters:
    ///   - red: The red component of the color.
    ///   - green: The green component of the color.
    ///   - blue: The blue component of the color.
    convenience init(red: Int, green: Int, blue: Int)
    {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Initializes an `SSColor` instance from RBG components and an alpha value.
    ///
    /// - Parameters:
    ///   - red: The red component of the color.
    ///   - green: The green component of the color.
    ///   - blue: The blue component of the color.
    ///   - alpha: The alpha value which the color should be displayed with.
    init(red: Int, green: Int, blue: Int, alpha: Float)
    {
        self.data = [Float(red), Float(green), Float(blue), alpha]
    }
}

// MARK: -
// MARK: -

/// The gradient utility class of the application.
class SSGradient
{
    // MARK: Properties
    
    /// The color stops of the gradient.
    var stops: [SSGradientStop]
    
    /// The start point of the gradient (required if used by a `CAGradientLayer`).
    var startPoint: CGPoint
    
    /// The end point of the gradient (required if used by a `CAGradientLayer`).
    var endPoint: CGPoint
    
    // MARK: - Initializers
    
    /// Initializes an `SSGradient` out of the given parameters.
    ///
    /// - Parameter stops: The color stops of the gradient.
    init(startPoint: CGPoint, endPoint: CGPoint, stops: SSGradientStop...)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        self.stops = stops.sorted(by: { (first, second) -> Bool in
            first.point < second.point
        })
    }
    
    /// Initializes an `SSGradient` out of the given parameters.
    ///
    /// - Parameter stops: The color stops of the gradient.
    init(startPoint: CGPoint, endPoint: CGPoint, stops: [SSGradientStop])
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        self.stops = stops.sorted(by: { (first, second) -> Bool in
            first.point < second.point
        })
    }
    
    // MARK: Methods
    
    /// Creates a `CAGradientLayer` out of the gradient.
    ///
    /// - Returns: The `CAGradientLayer` representation of the gradient.
    func gradientLayer() -> CAGradientLayer
    {
        let result: CAGradientLayer = CAGradientLayer()
        
        result.startPoint = startPoint
        result.endPoint = endPoint
        result.colors = [CGColor]()
        result.locations = [NSNumber]()
        
        for stop in stops
        {
            result.colors?.append(stop.color.uiColor.cgColor)
            result.locations?.append(NSNumber(value: stop.point))
        }
        
        return result
    }
    
    /// Creates a `CAGradientLayer` from the given layer with the gradient.
    ///
    /// - Parameters:
    ///   - layer: The layer which the `CAGradientLayer` should be copied from.
    func gradientLayer(layer: CALayer) -> CAGradientLayer
    {
        let result: CAGradientLayer = CAGradientLayer()
        
        result.frame = layer.bounds
        result.startPoint = startPoint
        result.endPoint = endPoint
        result.colors = [CGColor]()
        result.locations = [NSNumber]()
        
        for stop in stops
        {
            result.colors?.append(stop.color.uiColor.cgColor)
            result.locations?.append(NSNumber(value: stop.point))
        }
        
        return result
    }
    
    /// Applies the gradient to an existing gradient layer.
    ///
    /// - Parameter gradientLayer: The gradient layer the gradient should be applied to.
    func toGradientLayer(_ gradientLayer: CAGradientLayer)
    {
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [CGColor]()
        gradientLayer.locations = [NSNumber]()
        
        for stop in stops
        {
            gradientLayer.colors?.append(stop.color.uiColor.cgColor)
            gradientLayer.locations?.append(NSNumber(value: stop.point))
        }
    }
    
    // MARK: Static functions
    
    /// Compiles the given gradient code and initializes an `SSGradient` from it.
    ///
    /// - Parameter gradientCode: The raw gradient code.
    /// - Returns: The initialized `SSGradient`.
    static func compile(_ gradientCode: String) -> SSGradient?
    {
        var raw: String = gradientCode.components(separatedBy: .whitespacesAndNewlines).joined()
        
        var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
        var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)
        var stops: [SSGradientStop] = [SSGradientStop]()
        
        let squareBracketIndex: String.Index? = raw.index(of: "[")
        let squareBracketCloseIndex: String.Index? = raw.index(of: "]")
        
        if(squareBracketIndex != nil && squareBracketCloseIndex != nil)
        {
            let startEndPointSubstring: String = String(raw[raw.index(after: squareBracketIndex!)..<squareBracketCloseIndex!])
            let separatorIndex: String.Index? = startEndPointSubstring.index(of: ";")
            
            if(separatorIndex != nil)
            {
                let rawStartPoint: [String] = String(startEndPointSubstring[..<separatorIndex!]).components(separatedBy: ",")
                let rawEndPoint: [String] = String(startEndPointSubstring[startEndPointSubstring.index(after: separatorIndex!)...]).components(separatedBy: ",")
                
                startPoint = CGPoint(x: CGFloat(Float(rawStartPoint[0])!), y: CGFloat(Float(rawStartPoint[1])!))
                endPoint = CGPoint(x: CGFloat(Float(rawEndPoint[0])!), y: CGFloat(Float(rawEndPoint[1])!))
            }
            else
            {
                return nil
            }
            
            raw.removeSubrange(squareBracketIndex!...squareBracketCloseIndex!)
        }
        
        let separated: [String] = raw.components(separatedBy: "{")
        
        for component in separated
        {
            if(component != "")
            {
                let commaIndex: String.Index? = component.index(of: ",")
                let curlyBracketIndex: String.Index? = component.index(of: "}")
                
                if(commaIndex != nil && curlyBracketIndex != nil)
                {
                    let color: String = String(component[..<commaIndex!])
                    let point: String = String(component[component.index(after: commaIndex!)..<curlyBracketIndex!])
                    
                    stops.append(SSGradientStop(color: SSColor(hexadecimal: color), point: Float(point)!))
                }
                else
                {
                    return nil
                }
            }
        }
        
        return SSGradient(startPoint: startPoint, endPoint: endPoint, stops: stops)
        
        // Might implement it one day...
        /*let compliler: Compiler = Compiler(raw: gradientCode)
        return compliler.compiled()*/
    }
    
    // MARK: -
    
    /// The compiler which can compile a raw gradient code an create an `SSGradient` from it.
    class Compiler
    {
        // MARK: Properties
        
        /// The raw gradient code which is used to compile an `SSGradient`.
        var raw: String
        
        /// The start point of the gradient.
        private var startPoint: CGPoint
        
        /// The end point of the gradient.
        private var endPoint: CGPoint
        
        /// The color stops of the gradient.
        private var stops: [SSGradientStop]
        
        // MARK: - Initializers
        
        /// Initializes an `SSGradient.Compiler` object out of the given parameters.
        ///
        /// - Parameter raw: The raw gradient code which is used to compile an `SSGradient`.
        init(raw: String)
        {
            self.raw = raw
            
            self.startPoint = CGPoint(x: 0.0, y: 0.0)
            self.endPoint = CGPoint(x: 1.0, y: 1.0)
            self.stops = [SSGradientStop]()
        }
        
        // MARK: Methods
        
        /// Returns the compiled gradient from the raw gradient code.
        ///
        /// - Returns: The compiled `SSGradient`.
        func compiled() -> SSGradient
        {
            prepare()
            let tokens: [Token] = tokenize()
            compile()
            
            return SSGradient(startPoint: startPoint, endPoint: endPoint, stops: stops)
        }
        
        /// Prepares the raw gradient code before it can be compiled.
        private func prepare()
        {
            raw = raw.components(separatedBy: .whitespacesAndNewlines).joined()
        }
        
        /// Creates a set of tokens from the prepared raw gradient code.
        private func tokenize() -> [Token]
        {
            var result: [Token] = [Token]()
            var currentIndex: String.Index = raw.startIndex
            
            while true
            {
                parseToken(at: &currentIndex, context: nil, tokens: &result)
                
                if(currentIndex != raw.index(before: raw.endIndex))
                {
                    currentIndex = raw.index(after: currentIndex)
                }
                else
                {
                    return result
                }
            }
        }
        
        private func parseToken(at index: inout String.Index, context: Token?, tokens: inout [Token])
        {
            let character: Character = raw[index]
            
            switch character
            {
            case Token.separatorToken.representingString.first:
                if(context != nil)
                {
                    context!.addSubtoken(.separatorToken)
                }
                else
                {
                    tokens.append(.separatorToken)
                }
                
                index = raw.index(after: index)
                parseToken(at: &index, context: context, tokens: &tokens)
                break
              
            case Token.parameterOpenToken.representingString.first:
                let token: Token = .parameterToken
                token.addSubtoken(.parameterOpenToken)
                
                index = raw.index(after: index)
                parseToken(at: &index, context: token, tokens: &tokens)
                
                if(context != nil)
                {
                    context!.addSubtoken(token)
                }
                else
                {
                    tokens.append(token)
                }
                break
                
            case Token.parameterCloseToken.representingString.first:
                if(context != nil && (context == .parameterToken || context == .stopParameterToken))
                {
                    context!.addSubtoken(.parameterCloseToken)
                }
                break
                
            case Token.beginPointToken.representingString.first:
                let token: Token = .beginPointToken
                
                index = raw.index(after: index)
                parseToken(at: &index, context: token, tokens: &tokens)
                
                if(context != nil)
                {
                    context!.addSubtoken(token)
                }
                else
                {
                    tokens.append(token)
                }
                break
                
            case Token.endPointToken.representingString.first:
                let token: Token = .endPointToken
                
                index = raw.index(after: index)
                parseToken(at: &index, context: token, tokens: &tokens)
                
                if(context != nil)
                {
                    context!.addSubtoken(token)
                }
                else
                {
                    tokens.append(token)
                }
                break
                
            case Token.stopToken.representingString.first:
                let token: Token = .stopToken
                
                index = raw.index(after: index)
                parseToken(at: &index, context: token, tokens: &tokens)
                
                tokens.append(token)
                break
                
            case Token.colorToken.representingString.first:
                let token: Token = .colorToken
                
                index = raw.index(after: index)
                parseToken(at: &index, context: token, tokens: &tokens)
                
                if(context != nil)
                {
                    context!.addSubtoken(token)
                }
                else
                {
                    tokens.append(token)
                }
                break
                
            case Token.positionToken.representingString.first:
                let token: Token = .positionToken
                
                index = raw.index(after: index)
                parseToken(at: &index, context: token, tokens: &tokens)
                
                if(context != nil)
                {
                    context!.addSubtoken(token)
                }
                else
                {
                    tokens.append(token)
                }
                break
                
            default:
                if(context != nil)
                {
                    if(context!.subtokens.last!.unrecognized)
                    {
                        context!.subtokens.last!.representingString.append(character)
                    }
                    else
                    {
                        let token: Token = .unrecognized()
                        token.representingString = String(character)
                        
                        context!.addSubtoken(token)
                    }
                }
                else
                {
                    if(tokens.last!.unrecognized)
                    {
                        tokens.last!.representingString.append(character)
                    }
                    else
                    {
                        let token: Token = .unrecognized()
                        token.representingString = String(character)
                        
                        tokens.append(token)
                    }
                }
                
                index = raw.index(after: index)
                parseToken(at: &index, context: context, tokens: &tokens)
                break
            }
        }
        
        /// Compiles the set of tokens into properties of a gradient.
        private func compile()
        {
            
        }
        
        // MARK: -
        
        ///
        class Token: Equatable
        {
            // MARK: Static variables
            static let separatorToken: Token = Token(representingString: ";")
            static let parameterToken: Token = Token(representingString: "")
            static let parameterOpenToken: Token = Token(representingString: "(", wantedContext: parameterToken)
            static let parameterCloseToken: Token = Token(representingString: ")", wantedContext: parameterToken)
            static let beginPointToken: Token = Token(representingString: "b", expected: parameterToken)
            static let endPointToken: Token = Token(representingString: "e", expected: parameterToken)
            static let stopToken: Token = Token(representingString: "s", expected: parameterToken)
            static let stopParameterToken: Token = Token(representingString: "", wantedContext: stopToken, wantedSubtokens: [parameterOpenToken, parameterCloseToken])
            static let colorToken: Token = Token(representingString: "c", wantedContext: stopParameterToken, expected: parameterToken)
            static let positionToken: Token = Token(representingString: "p", wantedContext: stopParameterToken, expected: parameterToken)
            
            // MARK: Properties
            
            /// Indicates whether the token is unrecognized.
            var unrecognized: Bool
            
            /// The character which represents the token in raw code.
            var representingString: String
            
            /// The token which is expected to come after the current token.
            var expected: Token?
            
            /// The tokens which must be subtokens of the current token.
            var wantedSubtokens: [Token]?
            
            /// The token which must serve as the context for the current token.
            var wantedContext: Token?
            
            /// The token which provides the context for the current token.
            var context: Token?
            
            /// The subtokens of the current token.
            var subtokens: [Token]
            {
                return _subtokens
            }
            
            // INTERNAL VALUES //
            
            /// The internal value of the subtokens of the current token.
            private var _subtokens: [Token]
            
            // MARK: - Initializers
            
            /// Initializes an `SSGradient.Compiler.Token` object out of the given parameters.
            ///
            /// - Parameters:
            ///   - representingString: The character which represents the token in raw code.
            ///   - wantedContext: The token which must serve as the context for the current token.
            ///   - expected: The token which is expected to come after the current token.
            ///   - wantedSubtokens: The tokens which must be subtokens of the current token.
            init(representingString: String, wantedContext: Token? = nil, expected: Token? = nil, wantedSubtokens: [Token]? = nil)
            {
                self.unrecognized = false
                self.representingString = representingString
                self.expected = expected
                self.wantedSubtokens = wantedSubtokens
                self._subtokens = [Token]()
            }
            
            /// Initializes an unrecognized `SSGradient.Compiler.Token`.
            private init()
            {
                self.unrecognized = true
                self.representingString = ""
                self._subtokens = [Token]()
            }
            
            /// Adds a subtoken to the token.
            ///
            /// - Parameter token: The token which should be added as a subtoken to the current token.
            func addSubtoken(_ token: Token)
            {
                token.context = self
                _subtokens.append(token)
            }
            
            /// Adds a set of subtokens to the token.
            ///
            /// - Parameter token: The token which should be added as a subtoken to the current token.
            func addSubtokens(_ tokens: [Token])
            {
                for token in tokens
                {
                    token.context = self
                }
                
                _subtokens.append(contentsOf: tokens)
            }
            
            /// Removes the token from its context (supertoken).
            func removeFromContext()
            {
                context!._subtokens.remove(at: context!.subtokens.index(of: self)!)
            }
            
            // MARK: Static functions
            static func ==(lhs: SSGradient.Compiler.Token, rhs: SSGradient.Compiler.Token) -> Bool
            {
                if(lhs.unrecognized)
                {
                    return lhs.unrecognized == rhs.unrecognized
                }
                else
                {
                    return lhs.representingString == rhs.representingString && lhs.expected == rhs.expected && lhs.wantedSubtokens == rhs.wantedSubtokens && lhs.wantedContext == rhs.wantedContext
                }
            }
            
            static func unrecognized() -> Token
            {
                return Token()
            }
        }
    }
}

// MARK: -
// MARK: -

class SSGradientStop
{
    /// The color of the gradient stop.
    var color: SSColor
    
    /// The point where the stop is located within the gradient (from 0.0 to 1.0).
    var point: Float
    
    /// Initializes an `SSGradientStop` out of the given parameters.
    ///
    /// - Parameters:
    ///   - color: The color of the gradient stop.
    ///   - point: The point where the stop is located within the gradient (from 0.0 to 1.0).
    init(color: SSColor, point: Float)
    {
        self.color = color
        self.point = point
    }
}

// MARK: -
// MARK: -

/// A cubic curve which defines the pacing of an animation.
class SSCubicTimingCurve
{
    // MARK: Properties
    
    /// The first control point of the cubic curve.
    var controlPoint1: CGPoint
    
    /// The second control point of the cubic curve.
    var controlPoint2: CGPoint
    
    /// The first polynomial coefficient of the cubic curve which is equal to: `3 * controlPoint1`
    var coefficient1: CGPoint
    
    /// The second polynomial coefficient of the cubic curve which is equal to: `3 * (controlPoint2 - controlPoint1)`
    var coefficient2: CGPoint
    
    /// The third polynomial coefficient of the cubic curve which is equal to: `1 - 3 * (controlPoint2 + controlPoint1)`
    var coefficient3: CGPoint
    
    /// The `CAMediaTimingFunction` representation of the cubic curve.
    var caMediaTimingFunction: CAMediaTimingFunction
    {
        return CAMediaTimingFunction(controlPoints: Float(controlPoint1.x), Float(controlPoint1.y), Float(controlPoint2.x), Float(controlPoint2.y))
    }
    
    /// The `UICubicTimingParameters` representation of the cubic curve.
    var uiCubicTimingParameters: UICubicTimingParameters
    {
        return UICubicTimingParameters(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    // MARK: - Initializers
    
    /// Initializes an `SSCubicTimingCurve` out of the given parameters.
    ///
    /// - Parameters:
    ///   - x1: The "x" coordinate of the cubic curve's first control point.
    ///   - y1: The "y" coordinate of the cubic curve's first control point.
    ///   - x2: The "x" coordinate of the cubic curve's second control point.
    ///   - y2: The "y" coordinate of the cubic curve's second control point.
    convenience init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)
    {
        self.init(controlPoint1: CGPoint(x: x1, y: y1), controlPoint2: CGPoint(x: x2, y: y2))
    }
    
    /// Initializes an `SSCubicTimingCurve` out of the given parameters.
    ///
    /// - Parameters:
    ///   - controlPoint1: The first control point of the cubic curve.
    ///   - controlPoint2: The second control point of the cubic curve.
    init(controlPoint1: CGPoint, controlPoint2: CGPoint)
    {
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        
        // Calculate the polynomial coefficients.
        // The start point of the curve is always (0.0, 0.0) and the end point is always (1.0, 1.0)
        coefficient1 = (controlPoint1.distance * 3).point                                       // C1 = 3P1
        coefficient2 = ((controlPoint2.distance - (controlPoint1.distance * 2)) * 3).point      // C2 = 3(P2 - 2P1)
        coefficient3 = (1 - ((controlPoint2.distance - controlPoint1.distance) * 3)).point      // C3 = 1 - 3(P2 - P1)
    }
    
    // MARK: Methods
    
    /// Interpolates the cubic curve at a given parametric value.
    ///
    /// - Parameter time: The parametric value which the curve should be interpolated at.
    /// - Returns: The interpolated value at the given parametric value.
    func interpolate(at time: CGFloat) -> CGFloat
    {
        // Expand the equation B(t) = C3 * time^3 + C2 * time^2 + C1 * time using Horner's method
        return ((((coefficient3.y * time) + coefficient2.y) * time) + coefficient1.y) * time
    }
    
    /// Approximates the parametric value at which the cubic curve interpolates to the given value.
    ///
    /// - Parameters:
    ///   - value: The value of the cubic curve at the parametric value (which should be calculated).
    ///   - duration: The absolute duration of the timing function. Specifying a duration increases the accuracy of the parametric value.
    /// - Returns: The parametric value at which the cubic curve interpolates to the given value.
    func parametricValue(for value: CGFloat, duration: CGFloat = 1.0) -> CGFloat?
    {
        let accuracyThreshold: CGFloat = self.accuracyThreshold(for: duration)
        
        var parametricValue: CGFloat = value
        var interpolatedValue: CGFloat
        
        var derivative: CGFloat
        
        // First, attempt to approximate the value using Newton's method (10 iterations)
        for _ in 0..<10
        {
            // Interpolate the value for the current approximated parametric value
            interpolatedValue = interpolate(at: parametricValue) - value

            // Check if the difference between the value and the interpolated value is less than the accuracy threshold
            if(fabs(interpolatedValue) <= accuracyThreshold)
            {
                // Return the approximated parametric value
                return parametricValue
            }
            
            // Derive the timing curve at the current parametric value
            derivative = derive(at: parametricValue)
            
            // Check if the derivative has a large enough change
            if(fabs(derivative) <= 1e-6)
            {
                break
            }
            
            // Approximate the parametric value
            parametricValue = parametricValue - (interpolatedValue / derivative)
        }
        
        // If approximating using Newton's method has failed, try to approximate using the bisection method
        
        var lowerBound: CGFloat = 0.0
        var upperBound: CGFloat = 1.0
        
        parametricValue = value
        
        while(lowerBound < upperBound)
        {
            // Interpolate the value for the current approximated parametric value
            interpolatedValue = interpolate(at: parametricValue)
            
            // Check if the difference between the value and the interpolated value is less than the accuracy threshold
            if(fabs(interpolatedValue - value) <= accuracyThreshold)
            {
                // Return the approximated parametric value
                return parametricValue
            }
            
            // Check if the interpolated value is negative or positive in relation to the given interpolated value
            if(interpolatedValue < value)
            {
                lowerBound = parametricValue
            }
            else
            {
                upperBound = parametricValue
            }
            
            // Approximate the parametric value
            parametricValue = ((upperBound - lowerBound) / 2) + lowerBound
        }
        
        // Return nil to indicate that the approximation has failed
        return nil
    }
    
    /// Derives the cubic curve at a given parametric value.
    ///
    /// - Parameter time: The parametric value which the curve should be derived at.
    /// - Returns: The derivative of the curve at the given parametric value.
    private func derive(at time: CGFloat) -> CGFloat
    {
        // Expand the equation B'(t) = 3C3 * time^2 + 2C2 * time + C1 using Horner's method
        return (((3 * coefficient3.x * time) + (2 * coefficient2.x)) * time) + coefficient1.x
    }
    
    /// Calculates the accuracy threshold which should be used when evaluating a parametric value of a given value.
    ///
    /// - Parameter duration: The duration which should
    /// - Returns: The accuracy threshold.
    private func accuracyThreshold(for duration: CGFloat) -> CGFloat
    {
        return 1.0 / (1000.0 * duration)
    }
}

// MARK: -
extension SSCubicTimingCurve
{
    /// The default linear timing curve.
    static var linear: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.0, y1: 0.0, x2: 1.0, y2: 1.0)
    }
    
    /// The default ease in curve.
    static var easeIn: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.42, y1: 0.0, x2: 1.0, y2: 1.0)
    }
    
    /// The default ease out curve.
    static var easeOut: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.0, y1: 0.0, x2: 0.58, y2: 1.0)
    }
    
    /// The default ease in-out curve.
    static var easeInOut: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.42, y1: 0.0, x2: 0.58, y2: 1.0)
    }
    
    /// The default curve that the system uses.
    static var systemDefault: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.25, y1: 0.1, x2: 0.25, y2: 1.0)
    }
    
    /// A curve with subtle ease in and strong ease out.
    ///
    /// Its control points are: 0.25, 0.1, 0.125, 1.0
    static var ssEaseInOUT: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.25, y1: 0.1, x2: 0.125, y2: 1.0)
    }
    
    /// A curve with strong ease in and subtle ease out.
    ///
    /// Its control points are: 0.5, 0.3, 0.125, 1.0
    static var ssEaseINOut: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(x1: 0.5, y1: 0.3, x2: 0.125, y2: 1.0)
    }
}

// MARK: -
// MARK: -

/// The general utility functions of the application.
class SSUtilities
{
    
}
