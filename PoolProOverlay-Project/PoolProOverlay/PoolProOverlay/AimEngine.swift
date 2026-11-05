import CoreGraphics

/// Geometric aiming helper for a manually calibrated, top-down pool-table image.
/// This is a straight-line approximation, not a full spin/friction simulation.
struct AimEngine {
    func geometry(cue: CGPoint, object: CGPoint, ballRadius: CGFloat,
                  rayLength: CGFloat, table: CGRect) -> AimGeometry {
        let cueV = Vec2(cue)
        let objectV = Vec2(object)
        let delta = objectV - cueV
        let distance = delta.length
        let direction = delta.normalized
        let contact = objectV - direction * (ballRadius * 2)
        let rayEnd = cueV + direction * rayLength
        let objectEnd = objectV + direction * min(rayLength * 0.55, 260)

        return AimGeometry(
            cueCenter: cue,
            objectCenter: object,
            contactPoint: contact.cgPoint,
            cueRayEnd: rayEnd.cgPoint,
            objectDirectionEnd: objectEnd.cgPoint,
            valid: distance > ballRadius * 2.05 && table.contains(cue) && table.contains(object)
        )
    }

    /// Calculates the tangent direction after an idealized ball-to-ball collision.
    /// Real outcomes vary with speed, spin, cloth, cushion and collision offset.
    func objectBallDirection(cue: CGPoint, object: CGPoint) -> CGVector {
        let d = Vec2(object) - Vec2(cue)
        let n = d.normalized
        return CGVector(dx: n.x, dy: n.y)
    }
}
