import SwiftUI

struct Vec2: Equatable {
    var x: CGFloat
    var y: CGFloat

    static func + (lhs: Vec2, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func - (lhs: Vec2, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static func * (lhs: Vec2, rhs: CGFloat) -> Vec2 {
        Vec2(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    var length: CGFloat { hypot(x, y) }
    var normalized: Vec2 {
        let magnitude = max(length, 0.0001)
        return Vec2(x: x / magnitude, y: y / magnitude)
    }
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
    init(_ point: CGPoint) { x = point.x; y = point.y }
    init(x: CGFloat, y: CGFloat) { self.x = x; self.y = y }
}

enum BallKind: String, CaseIterable {
    case cue = "Bi cái"
    case object = "Bi mục tiêu"
}

struct AimGeometry {
    let cueCenter: CGPoint
    let objectCenter: CGPoint
    let contactPoint: CGPoint
    let cueRayEnd: CGPoint
    let objectDirectionEnd: CGPoint
    let valid: Bool
}
