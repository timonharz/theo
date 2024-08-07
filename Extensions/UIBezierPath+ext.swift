//
//  File.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import Foundation
import UIKit

extension UIBezierPath {
    func generatePathPoints() -> [[CGPoint]] {
        let points = cgPath.points()
        guard points.count > 0 else {
            return []
        }
        var paths = [[CGPoint]]()
        var pathPoints = [CGPoint]()
        var previousPoint: CGPoint?
        let stopDistance: CGFloat = 10
        for command in points {
            let endPoint = command.point
            defer {
                previousPoint = endPoint
            }
            guard let startPoint = previousPoint else {
                continue
            }
            let pointCalculationFunc: (CGFloat) -> CGPoint
            switch command.type {
            case .addLineToPoint:
                // Line
                pointCalculationFunc = {
                    calculateLinear(t: $0, p1: startPoint, p2: endPoint)
                }
            case .addQuadCurveToPoint:
                pointCalculationFunc = {
                    calculateQuad(t: $0, p1: startPoint, p2: command.controlPoints[0], p3: endPoint)
                }
            case .addCurveToPoint:
                pointCalculationFunc = {
                    calculateCube(t: $0, p1: startPoint, p2: command.controlPoints[0], p3: command.controlPoints[1], p4: endPoint)
                }
            case .closeSubpath:
                previousPoint = nil
                fallthrough
            case .moveToPoint:
                if !pathPoints.isEmpty {
                    paths.append(pathPoints)
                    pathPoints = []
                }
                continue
            @unknown default:
                continue
            }

            let initialCurvePoints = [
                CurvePoint(position: 0, cgPointGenerator: pointCalculationFunc),
                CurvePoint(position: 1, cgPointGenerator: pointCalculationFunc),
            ]
            let curvePoints = calculatePoints(
                tRange: 0...1,
                pointCalculationFunc: pointCalculationFunc,
                leftPoint: initialCurvePoints[0].cgPoint,
                stopDistance: stopDistance
            ) + initialCurvePoints
            pathPoints.append(
                contentsOf:
                    curvePoints
                    .sorted { $0.position < $1.position }
                    .map { $0.cgPoint }
            )
            previousPoint = endPoint
        }
        if !pathPoints.isEmpty {
            paths.append(pathPoints)
            pathPoints = []
        }
        return paths
    }

    private func calculatePoints(
        tRange: ClosedRange<CGFloat>,
        pointCalculationFunc: (CGFloat) -> CGPoint,
        leftPoint: CGPoint,
        stopDistance: CGFloat
    ) -> [CurvePoint] {
        let middlePoint = CurvePoint(position: (tRange.lowerBound + tRange.upperBound) / 2, cgPointGenerator: pointCalculationFunc)
        if hypot(leftPoint.x - middlePoint.cgPoint.x, leftPoint.y - middlePoint.cgPoint.y) < stopDistance {
            return [middlePoint]
        }
        let leftHalfPoints = calculatePoints(tRange: tRange.lowerBound...middlePoint.position, pointCalculationFunc: pointCalculationFunc, leftPoint: leftPoint, stopDistance: stopDistance)
        let rightHalfPoints = calculatePoints(tRange: middlePoint.position...tRange.upperBound, pointCalculationFunc: pointCalculationFunc, leftPoint: middlePoint.cgPoint, stopDistance: stopDistance)
        return leftHalfPoints + rightHalfPoints + [middlePoint]
    }
}

private struct CurvePoint {
    let position: CGFloat
    let cgPoint: CGPoint

    init(position: CGFloat, cgPointGenerator: (CGFloat) -> CGPoint) {
        self.position = position
        self.cgPoint = cgPointGenerator(position)
    }
}

struct PathCommand {
    let type: CGPathElementType
    let point: CGPoint
    let controlPoints: [CGPoint]
}

// http://stackoverflow.com/a/38743318/1321917
extension CGPath {
    func points() -> [PathCommand] {
        var bezierPoints = [PathCommand]()
        forEachPoint { element in
            guard element.type != .closeSubpath else {
                return
            }
            let numberOfPoints: Int = {
                switch element.type {
                case .moveToPoint, .addLineToPoint: // contains 1 point
                    return 1
                case .addQuadCurveToPoint: // contains 2 points
                    return 2
                case .addCurveToPoint: // contains 3 points
                    return 3
                case .closeSubpath:
                    return 0
                @unknown default:
                    fatalError()
                }
            }()
            var points = [CGPoint]()
            for index in 0..<(numberOfPoints - 1) {
                let point = element.points[index]
                points.append(point)
            }
            let command = PathCommand(type: element.type, point: element.points[numberOfPoints - 1], controlPoints: points)
            bezierPoints.append(command)
        }
        return bezierPoints
    }

    private func forEachPoint(body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(_ info: UnsafeMutableRawPointer?, _ element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        withoutActuallyEscaping(body) { body in
            let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
            apply(info: unsafeBody, function: callback as CGPathApplierFunction)
        }
    }
}

/// Calculates a point at given t value, where t in 0.0...1.0
private func calculateLinear(t: CGFloat, p1: CGPoint, p2: CGPoint) -> CGPoint {
    let mt = 1 - t
    let x = mt*p1.x + t*p2.x
    let y = mt*p1.y + t*p2.y
    return CGPoint(x: x, y: y)
}

/// Calculates a point at given t value, where t in 0.0...1.0
private func calculateCube(t: CGFloat, p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> CGPoint {
    let mt = 1 - t
    let mt2 = mt*mt
    let t2 = t*t

    let a = mt2*mt
    let b = mt2*t*3
    let c = mt*t2*3
    let d = t*t2

    let x = a*p1.x + b*p2.x + c*p3.x + d*p4.x
    let y = a*p1.y + b*p2.y + c*p3.y + d*p4.y
    return CGPoint(x: x, y: y)
}

/// Calculates a point at given t value, where t in 0.0...1.0
private func calculateQuad(t: CGFloat, p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint {
    let mt = 1 - t
    let mt2 = mt*mt
    let t2 = t*t

    let a = mt2
    let b = mt*t*2
    let c = t2

    let x = a*p1.x + b*p2.x + c*p3.x
    let y = a*p1.y + b*p2.y + c*p3.y
    return CGPoint(x: x, y: y)
}
