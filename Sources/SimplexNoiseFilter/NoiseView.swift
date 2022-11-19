import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct NoiseView: View {
    var contrast: Float = 1

    var octaves: Int = 8

    @Environment(\.displayScale)
    var displayScale

    public var body: some View {
        GeometryReader { p in
            image(bounds: CGRect(origin: .zero, size: p.size))
        }
    }

    func image(bounds: CGRect) -> Image? {
        let context: CIContext

        if let device = MTLCreateSystemDefaultDevice() {
            context = CIContext(mtlDevice: device)
        } else {
            context = CIContext()
        }

        let filter = FractalNoiseGenerator()
        filter.contrast = 2
        filter.octaves = 8
        filter.zoom = Float(displayScale)

        let bounds = bounds
            .applying(.init(scaleX: displayScale, y: displayScale))

        guard let output = filter.outputImage else {
            return nil
        }

        guard let result = context.createCGImage(output, from: bounds) else {
            return nil
        }

        return Image(decorative: result, scale: displayScale)
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
struct NoiseView_Previews: PreviewProvider {
    static var previews: some View {
        NoiseView()
            .edgesIgnoringSafeArea(.all)
    }
}
