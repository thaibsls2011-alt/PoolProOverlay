import SwiftUI

struct ContentView: View {
    @State private var cue = CGPoint(x: 105, y: 170)
    @State private var object = CGPoint(x: 245, y: 170)
    @State private var selectedBall: BallKind = .cue
    @State private var guideLength: Double = 420
    @State private var ballDiameter: Double = 22
    @State private var showObjectPath = true
    @State private var showContact = true
    @State private var showGrid = false

    private let engine = AimEngine()

    var body: some View {
        VStack(spacing: 14) {
            header
            GeometryReader { proxy in
                let table = tableRect(in: proxy.size)
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.035, green: 0.34, blue: 0.22))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.brown.opacity(0.9), lineWidth: 12))
                    if showGrid { grid(in: table) }
                    tableDrawing(in: table)
                    ball(at: cue, color: .white, label: "C")
                    ball(at: object, color: .orange, label: "●")
                    if table.width > 0 {
                        let result = engine.geometry(cue: cue, object: object,
                            ballRadius: CGFloat(ballDiameter / 2),
                            rayLength: CGFloat(guideLength), table: table)
                        Path { path in
                            path.move(to: cue)
                            path.addLine(to: clamp(result.cueRayEnd, to: table))
                        }
                        .stroke(result.valid ? Color.cyan : Color.red,
                                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [8, 5]))
                        if showContact && result.valid {
                            Circle().fill(Color.yellow).frame(width: 9, height: 9)
                                .position(result.contactPoint)
                        }
                        if showObjectPath && result.valid {
                            Path { path in
                                path.move(to: object)
                                path.addLine(to: clamp(result.objectDirectionEnd, to: table))
                            }
                            .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                        }
                    }
                    dragHandle(for: .cue, in: table)
                    dragHandle(for: .object, in: table)
                }
                .coordinateSpace(name: "poolTable")
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(alignment: .bottom) {
                    Text("Kéo các bi để đặt vị trí • Mô phỏng hình học 2D")
                        .font(.caption2.weight(.medium))
                        .padding(7)
                        .background(.black.opacity(0.48), in: Capsule())
                        .padding(.bottom, 8)
                }
            }
            .frame(height: 310)
            controls
            footer
        }
        .padding(16)
        .background(Color(red: 0.055, green: 0.065, blue: 0.08))
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("POOL PRO").font(.system(size: 22, weight: .black, design: .rounded))
                Text("PRECISION TABLE ANALYZER").font(.system(size: 9, weight: .bold, design: .monospaced)).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "scope").font(.title2).foregroundStyle(.cyan)
        }.foregroundStyle(.white)
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Điều khiển").font(.headline)
                Spacer()
                Button("Đặt lại") { cue = CGPoint(x: 105, y: 170); object = CGPoint(x: 245, y: 170) }
                    .font(.caption.weight(.semibold))
            }
            HStack {
                Text("Độ dài đường ngắm")
                Spacer()
                Text("\(Int(guideLength)) px").monospacedDigit().foregroundStyle(.cyan)
            }.font(.subheadline)
            Slider(value: $guideLength, in: 80...900, step: 10).tint(.cyan)
            HStack {
                Text("Đường bi mục tiêu")
                Spacer()
                Toggle("", isOn: $showObjectPath).labelsHidden().tint(.orange)
            }
            HStack {
                Text("Điểm tiếp xúc")
                Spacer()
                Toggle("", isOn: $showContact).labelsHidden().tint(.yellow)
            }
            HStack {
                Text("Lưới căn chỉnh")
                Spacer()
                Toggle("", isOn: $showGrid).labelsHidden()
            }
            HStack {
                Text("Đường kính bi")
                Spacer()
                Slider(value: $ballDiameter, in: 14...34, step: 1).frame(width: 140)
                Text("\(Int(ballDiameter))").monospacedDigit().frame(width: 24)
            }.font(.subheadline)
        }
        .foregroundStyle(.white)
        .padding(14)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }

    private var footer: some View {
        Text("Lưu ý: cần tự đặt vị trí bi. Kết quả là đường hình học lý tưởng, không bảo đảm chính xác tuyệt đối trong trận thật.")
            .font(.caption2).foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func tableRect(in size: CGSize) -> CGRect {
        CGRect(x: 16, y: 16, width: max(0, size.width - 32), height: max(0, size.height - 32))
    }

    private func tableDrawing(in rect: CGRect) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.22), lineWidth: 1)
                .padding(10)
            HStack {
                ForEach(0..<6) { _ in
                    Circle().fill(Color.black.opacity(0.55)).frame(width: 9, height: 9)
                    Spacer()
                }
            }.padding(.horizontal, 2)
        }
    }

    private func grid(in rect: CGRect) -> some View {
        Path { path in
            stride(from: rect.minX, through: rect.maxX, by: 30).forEach {
                path.move(to: CGPoint(x: $0, y: rect.minY)); path.addLine(to: CGPoint(x: $0, y: rect.maxY))
            }
            stride(from: rect.minY, through: rect.maxY, by: 30).forEach {
                path.move(to: CGPoint(x: rect.minX, y: $0)); path.addLine(to: CGPoint(x: rect.maxX, y: $0))
            }
        }.stroke(Color.white.opacity(0.12), lineWidth: 0.5)
    }

    private func ball(at point: CGPoint, color: Color, label: String) -> some View {
        Circle().fill(color.gradient)
            .overlay(Circle().stroke(Color.black.opacity(0.35), lineWidth: 1))
            .overlay(Text(label).font(.system(size: 9, weight: .black)).foregroundStyle(.black.opacity(0.65)))
            .frame(width: ballDiameter, height: ballDiameter)
            .position(point)
            .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
    }

    private func dragHandle(for kind: BallKind, in rect: CGRect) -> some View {
        let point = kind == .cue ? cue : object
        return Circle().fill(Color.clear).frame(width: 42, height: 42)
            .contentShape(Circle()).position(point)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named("poolTable")).onChanged { value in
                let p = CGPoint(x: min(max(value.location.x, rect.minX + 15), rect.maxX - 15),
                                y: min(max(value.location.y, rect.minY + 15), rect.maxY - 15))
                if kind == .cue { cue = p } else { object = p }
            })
    }

    private func clamp(_ point: CGPoint, to rect: CGRect) -> CGPoint {
        CGPoint(x: min(max(point.x, rect.minX), rect.maxX),
                y: min(max(point.y, rect.minY), rect.maxY))
    }
}
