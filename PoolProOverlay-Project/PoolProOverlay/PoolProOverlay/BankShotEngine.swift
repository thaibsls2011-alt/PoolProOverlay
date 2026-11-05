import CoreGraphics

struct BankShotEngine {
    enum Rail: Equatable { case left, right, top, bottom }

    /// Mirrors the target across one rail. Draw a line from cue to this virtual target,
    /// then intersect it with the selected rail to get the ideal reflection point.
    func virtualTarget(_ target: CGPoint, in table: CGRect, rail: Rail) -> CGPoint {
        switch rail {
        case .left:
            return CGPoint(x: 2 * table.minX - target.x, y: target.y)
        case .right:
            return CGPoint(x: 2 * table.maxX - target.x, y: target.y)
        case .top:
            return CGPoint(x: target.x, y: 2 * table.minY - target.y)
        case .bottom:
            return CGPoint(x: target.x, y: 2 * table.maxY - target.y)
        }
    }

    func intersection(from start: CGPoint, to virtualEnd: CGPoint,
                      with table: CGRect, rail: Rail) -> CGPoint? {
        let dx = virtualEnd.x - start.x
        let dy = virtualEnd.y - start.y
        switch rail {
        case .left, .right:
            let x = rail == .left ? table.minX : table.maxX
            guard abs(dx) > 0.0001 else { return nil }
            let t = (x - start.x) / dx
            guard (0...1).contains(t) else { return nil }
            let y = start.y + t * dy
            guard table.minY...table.maxY ~= y else { return nil }
            return CGPoint(x: x, y: y)
        case .top, .bottom:
            let y = rail == .top ? table.minY : table.maxY
            guard abs(dy) > 0.0001 else { return nil }
            let t = (y - start.y) / dy
            guard (0...1).contains(t) else { return nil }
            let x = start.x + t * dx
            guard table.minX...table.maxX ~= x else { return nil }
            return CGPoint(x: x, y: y)
        }
    }
}
